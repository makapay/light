from light import Ui_MainWindow
from light_window import Ui_Form
import MySQLdb as mdb
from PyQt6 import QtWidgets, QtCore
from PyQt6.QtWidgets import QVBoxLayout, QCheckBox
from qwer_scrin import QwSql
from itertools import chain
from light import *
from qwer_scrin import *


class Main(QtWidgets.QMainWindow,Ui_Form):
    def __init__(self, parent=None):
        super(Main, self).__init__(parent)
        self.setupUi(self)
        self.checks = []  # для чекбоксов
        self.rates = []  # для учёта скидок
        self.rates2 = None  # для тарифа
        self.dif_read = None  # для разницы показаний
        self.id_prib = None  # id прибора
        self.amount = None
        self.newRead = None  # показания счётчика
        self.id_tarif = None
        data_qw = QwSql().get_combo()
        xp1 = QwSql().get_privil
        get_tarifs = QwSql().get_tarifs()
        for i in data_qw:
            self.comboBox.addItem(i[1])

        self.comboBox.model().item(0).setEnabled(False)
        self.comboBox.currentTextChanged.connect(lambda: self.comboChangedBackground(data_qw, xp1))
        self.btn_calc.clicked.connect(self.onClickCheck)
        self.btn_write.clicked.connect(self.setAmount)

        height = 40
        for i in get_tarifs:
            rad = QtWidgets.QRadioButton(parent=self.grBox)
            rad.setGeometry(20, height, 191, 21)
            rad.setObjectName(f"{i[1]}")
            rad.setText(f"{i[1]}")
            rad.setAccessibleName(f"{i[0]}")
            rad.setAccessibleDescription(f"{i[2]}")
            rad.toggled.connect(self.on_togled)
            height += 40

    def on_togled(self, checked):
        radio = self.sender()
        if checked:
            self.rates2 = float(radio.accessibleDescription())
            self.id_tarif = radio.accessibleName()
            print(self.rates2)
            # print(radio.objectName())
            # print(radio.text())

    def onClickCheck(self):
        try:
            self.rates.clear()
            checked = (' '.join([checkbox.text() for checkbox in self.checks if checkbox.isChecked()])).split(' ')
            for i in checked:
                if i == '':
                    pass
                else:
                    self.rates.append(float(QwSql().get_rate(i)))
        except Exception as e:
            print('нет чекбоксов')
        print(self.rates)
        print(self.id_prib)
        read = self.lineEdit.text()
        self.newRead = read

        if read == '' or self.id_prib == None:
            pass
        else:
            try:
                self.dif_read = QwSql().get_read(self.id_prib, read)
            except Exception as e:
                print("не найдено предыдущих записей")
            try:
                if not self.rates:  # если список  пуст то делается расчёт без скидок
                    self.amount = float(self.dif_read) * float(self.rates2)

                    self.amount = round(self.amount, 2)
                else:
                    self.amount = float(self.dif_read) * float(self.rates2)
                    for i in self.rates:
                        self.amount *= i
                    self.amount = round(self.amount, 2)
            except:
                pass
        try:
            print(self.amount)
            self.ll.setText(str(self.amount))
            self.ll.adjustSize()
        except:
            pass

    def setAmount(self):
        try:
            QwSql().set_answer(self.newRead, self.amount, self.id_tarif, self.id_prib)
        except Exception as e:
            print("недотсаточно информации для запси в бд")

    def comboChangedBackground(self, data_qw, xp1):
        # очистка layout
        while self.VL.count():
            item = self.VL.takeAt(0)
            widget = item.widget()
            if widget:
                widget.deleteLater()

        comb = self.comboBox.currentText()
        new_data_qw = list(chain.from_iterable(data_qw))
        index = new_data_qw.index(comb) - 1
        element = new_data_qw[index]
        self.id_prib = element
        xp1 = xp1(element)
        for i in xp1[0]:
            if i != None:
                self.checkbox = QCheckBox(i)
                self.checks.append(self.checkbox)
                self.VL.addWidget(self.checkbox)

if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    wind = Main()
    wind.show()
    sys.exit(app.exec())

