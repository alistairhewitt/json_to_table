# json_to_table

A stored procedure in SQL that takes a **JSON object** as input which contains **n** key/value pairs.

The procedure uses a **Common Table Expression** and outputs a result set that contains two columns: **key** and **value**. If the input is invalid or not a JSON object, it throws error 333.

This procedure is intended for use with **MariaDB 10.4**.
