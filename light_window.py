# Form implementation generated from reading ui file 'light_window.ui'
#
# Created by: PyQt6 UI code generator 6.4.2
#
# WARNING: Any manual changes made to this file will be lost when pyuic6 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt6 import QtCore, QtGui, QtWidgets


class Ui_Form(object):
    def setupUi(self, Form):
        Form.setObjectName("Form")
        Form.resize(481, 591)
        Form.setStyleSheet("background-color: rgb(170, 255, 255);")
        self.label_device = QtWidgets.QLabel(parent=Form)
        self.label_device.setGeometry(QtCore.QRect(20, 20, 81, 31))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_device.setFont(font)
        self.label_device.setObjectName("label_device")
        self.comboBox = QtWidgets.QComboBox(parent=Form)
        self.comboBox.setGeometry(QtCore.QRect(10, 60, 201, 31))
        self.comboBox.setObjectName("comboBox")
        self.label_benefits = QtWidgets.QLabel(parent=Form)
        self.label_benefits.setGeometry(QtCore.QRect(10, 110, 131, 31))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_benefits.setFont(font)
        self.label_benefits.setObjectName("label_benefits")
        self.widget_benefits = QtWidgets.QWidget(parent=Form)
        self.widget_benefits.setGeometry(QtCore.QRect(10, 140, 241, 151))
        self.widget_benefits.setObjectName("widget_benefits")
        self.verticalLayoutWidget = QtWidgets.QWidget(parent=self.widget_benefits)
        self.verticalLayoutWidget.setGeometry(QtCore.QRect(10, 20, 191, 101))
        self.verticalLayoutWidget.setObjectName("verticalLayoutWidget")
        self.verticalLayout_benefits = QtWidgets.QVBoxLayout(self.verticalLayoutWidget)
        self.verticalLayout_benefits.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_benefits.setObjectName("verticalLayout_benefits")
        self.lineEdit_readings = QtWidgets.QLineEdit(parent=Form)
        self.lineEdit_readings.setGeometry(QtCore.QRect(20, 340, 281, 21))
        self.lineEdit_readings.setObjectName("lineEdit_readings")
        self.label_readings = QtWidgets.QLabel(parent=Form)
        self.label_readings.setGeometry(QtCore.QRect(20, 300, 151, 21))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_readings.setFont(font)
        self.label_readings.setObjectName("label_readings")
        self.grBox = QtWidgets.QGroupBox(parent=Form)
        self.grBox.setGeometry(QtCore.QRect(10, 400, 291, 81))
        self.grBox.setObjectName("grBox")
        self.btn_calc = QtWidgets.QPushButton(parent=Form)
        self.btn_calc.setGeometry(QtCore.QRect(10, 540, 161, 41))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.btn_calc.setFont(font)
        self.btn_calc.setObjectName("btn_calc")
        self.btn_write = QtWidgets.QPushButton(parent=Form)
        self.btn_write.setGeometry(QtCore.QRect(260, 540, 161, 41))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.btn_write.setFont(font)
        self.btn_write.setObjectName("btn_write")
        self.label_type_device = QtWidgets.QLabel(parent=Form)
        self.label_type_device.setGeometry(QtCore.QRect(20, 370, 121, 21))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_type_device.setFont(font)
        self.label_type_device.setObjectName("label_type_device")

        self.retranslateUi(Form)
        QtCore.QMetaObject.connectSlotsByName(Form)

    def retranslateUi(self, Form):
        _translate = QtCore.QCoreApplication.translate
        Form.setWindowTitle(_translate("Form", "Form"))
        self.label_device.setText(_translate("Form", "Счетчик:"))
        self.label_benefits.setText(_translate("Form", "Доступные льготы:"))
        self.label_readings.setText(_translate("Form", "Введите показания:"))
        self.grBox.setTitle(_translate("Form", "GroupBox"))
        self.btn_calc.setText(_translate("Form", "Рассчитать"))
        self.btn_write.setText(_translate("Form", "Записать"))
        self.label_type_device.setText(_translate("Form", "Тип счетчика:"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Form = QtWidgets.QWidget()
    ui = Ui_Form()
    ui.setupUi(Form)
    Form.show()
    sys.exit(app.exec())
