from io import StringIO
from pathlib import Path

import psycopg2
from psycopg2 import sql


TABLES = ("customers", "products", "product_categories", "orders", "order_items", "payments")


def main():
    source = psycopg2.connect(
        host="postgres", dbname="shop", user="student", password="studentpass"
    )
    target = psycopg2.connect(
        host="greenplum", dbname="dwh", user="gpadmin", password="gpadmin"
    )
    counts = {}
    try:
        source.set_session(readonly=True, isolation_level="REPEATABLE READ")
        with source, target, source.cursor() as src, target.cursor() as dst:
            ddl = Path(__file__).resolve().parents[1] / "init/greenplum/load_raw.sql"
            dst.execute(ddl.read_text(encoding="utf-8"))
            for table in TABLES:
                table_name = sql.Identifier(table)
                buffer = StringIO()
                src.copy_expert(
                    sql.SQL("copy public.{} to stdout with csv").format(table_name), buffer
                )
                buffer.seek(0)
                dst.execute(sql.SQL("truncate raw.{}").format(table_name))
                dst.copy_expert(
                    sql.SQL("copy raw.{} from stdin with csv").format(table_name), buffer
                )
                dst.execute(sql.SQL("analyze raw.{}").format(table_name))
                dst.execute(sql.SQL("select count(*) from raw.{}").format(table_name))
                counts[table] = dst.fetchone()[0]
        print("Готово: в Greenplum, база dwh, схема raw загружено строк:", flush=True)
        for table, count in counts.items():
            print(table, count, flush=True)
    finally:
        source.close()
        target.close()


if __name__ == "__main__":
    main()
