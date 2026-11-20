

from flask import Flask, jsonify, request
import mysql.connector
from datetime import date, datetime, time, timedelta

app = Flask(__name__)

# =====================================
# CONEXION A LA BASE DE DATOS
# =====================================

def conectar_bd():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="sistema_expediente"
    )


# =====================================
# CONVERTIR DATOS A FORMATO JSON
# =====================================

def convertir_json(registros):
    for registro in registros:
        for campo, valor in registro.items():

            if isinstance(valor, (date, datetime, time)):
                registro[campo] = valor.isoformat()

            elif isinstance(valor, timedelta):
                registro[campo] = str(valor)

    return registros


# =====================================
# RUTA PRINCIPAL
# =====================================

@app.route("/")
def inicio():
    return jsonify({
        "mensaje": "API Sistema de Expedientes funcionando correctamente"
    })


# =====================================
# CREATE - INSERT
# =====================================

@app.route("/api/expedientes", methods=["POST"])
def crear_expediente():

    datos = request.get_json()

    if not datos:
        return jsonify({"mensaje": "Debe enviar datos JSON"}), 400

    try:
        conexion = conectar_bd()
        cursor = conexion.cursor()

        sql = """
        INSERT INTO expedientes
        (numero_expediente, fecha_servicio, hora_servicio,
        id_usuario, id_aseguradora, id_juzgado,
        id_estado, observaciones)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """

        valores = (
            datos["numero_expediente"],
            datos["fecha_servicio"],
            datos["hora_servicio"],
            datos["id_usuario"],
            datos["id_aseguradora"],
            datos["id_juzgado"],
            datos["id_estado"],
            datos.get("observaciones", "")
        )

        cursor.execute(sql, valores)
        conexion.commit()

        nuevo_id = cursor.lastrowid

        cursor.close()
        conexion.close()

        return jsonify({
            "id_expediente": nuevo_id,
            "mensaje": "Expediente registrado correctamente"
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# =====================================
# READ - SELECT TODOS
# =====================================

@app.route("/api/expedientes", methods=["GET"])
def consultar_expedientes():

    try:
        conexion = conectar_bd()
        cursor = conexion.cursor(dictionary=True)

        cursor.execute("SELECT * FROM expedientes")

        expedientes = cursor.fetchall()

        expedientes = convertir_json(expedientes)

        cursor.close()
        conexion.close()

        return jsonify(expedientes), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# =====================================
# READ - SELECT POR ID
# =====================================

@app.route("/api/expedientes/<int:id>", methods=["GET"])
def consultar_expediente(id):

    try:
        conexion = conectar_bd()
        cursor = conexion.cursor(dictionary=True)

        cursor.execute(
            "SELECT * FROM expedientes WHERE id_expediente = %s",
            (id,)
        )

        expediente = cursor.fetchone()

        cursor.close()
        conexion.close()

        if expediente is None:
            return jsonify({
                "mensaje": "Expediente no encontrado"
            }), 404

        expediente = convertir_json([expediente])[0]

        return jsonify(expediente), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# =====================================
# UPDATE - ACTUALIZAR
# =====================================

@app.route("/api/expedientes/<int:id>", methods=["PUT"])
def actualizar_expediente(id):

    datos = request.get_json()

    if not datos:
        return jsonify({"mensaje": "Debe enviar datos JSON"}), 400

    try:
        conexion = conectar_bd()
        cursor = conexion.cursor()

        cursor.execute(
            "SELECT id_expediente FROM expedientes WHERE id_expediente = %s",
            (id,)
        )

        existe = cursor.fetchone()

        if existe is None:
            cursor.close()
            conexion.close()

            return jsonify({
                "mensaje": "Expediente no encontrado"
            }), 404

        sql = """
        UPDATE expedientes SET
        numero_expediente = %s,
        fecha_servicio = %s,
        hora_servicio = %s,
        id_usuario = %s,
        id_aseguradora = %s,
        id_juzgado = %s,
        id_estado = %s,
        observaciones = %s
        WHERE id_expediente = %s
        """

        valores = (
            datos["numero_expediente"],
            datos["fecha_servicio"],
            datos["hora_servicio"],
            datos["id_usuario"],
            datos["id_aseguradora"],
            datos["id_juzgado"],
            datos["id_estado"],
            datos.get("observaciones", ""),
            id
        )

        cursor.execute(sql, valores)
        conexion.commit()

        cursor.close()
        conexion.close()

        return jsonify({
            "mensaje": "Expediente actualizado correctamente"
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# =====================================
# DELETE - ELIMINAR
# =====================================

@app.route("/api/expedientes/<int:id>", methods=["DELETE"])
def eliminar_expediente(id):

    try:
        conexion = conectar_bd()
        cursor = conexion.cursor()

        cursor.execute(
            "DELETE FROM expedientes WHERE id_expediente = %s",
            (id,)
        )

        if cursor.rowcount == 0:
            cursor.close()
            conexion.close()

            return jsonify({
                "mensaje": "Expediente no encontrado"
            }), 404

        conexion.commit()

        cursor.close()
        conexion.close()

        return jsonify({
            "mensaje": "Expediente eliminado correctamente"
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# =====================================
# INICIAR SERVIDOR FLASK
# =====================================

if __name__ == "__main__":
    app.run(debug=True, port=5000)
