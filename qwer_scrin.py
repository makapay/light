import MySQLdb as mdb
db = mdb.connect(host='localhost', user='root', password='', database='light_meter_pav2')

class QwSql():

    def get_combo(self):
        cur = db.cursor()
        rows = cur.execute(f"SELECT * FROM MeteringDevice ")
        data_qw = cur.fetchall()
        cur.close()
        return data_qw


    def get_privil(self, id):
        cur = db.cursor()
        rows = cur.execute(f"call xp1('{id}')")
        data_qw = cur.fetchall()
        cur.close()
        return data_qw


    def get_tarifs(self):
        cur = db.cursor()
        rows = cur.execute(f"select * from Tariffs ")
        data_qw = cur.fetchall()
        cur.close()
        return data_qw

    def get_date(self, id):
        cur = db.cursor()
        rows = cur.execute(f"call xp2('{id}')")
        data_qw = cur.fetchall()
        cur.close()
        return data_qw



    def get_rate(self, name):
        cur = db.cursor()
        rows = cur.execute(f'SELECT rate FROM `PrivilegeTypes` WHERE name = "{name}";')
        data_qw = cur.fetchone()[0]
        cur.close()
        return data_qw


    def get_read(self, id, read):
        try:
            cur = db.cursor()
            rows = cur.execute(f"call xp3('{id}', '{read}')")
            data_qw = cur.fetchone()[0]
            print(data_qw)
            cur.close()
            return data_qw
        except Exception as e:
            return None



    def set_answer(self,reading, amount, id_tarif, id_prib):
        cur = db.cursor()
        rows = cur.execute(f'INSERT INTO MeterReadings (date_time, reading, amount, tariff_id, metering_device_id) VALUES (NOW(), "{reading}", "{amount}", "{id_tarif}", "{id_prib}") ')
        db.commit()
        cur.close()
        print('Ответ добавлен')




















