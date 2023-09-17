#include <iostream>

int main()
{
    int remainder, divisor;
    int quotient = 0;
    int delta = 1; // дельта для получения знакового частного
    bool negative_remainder = false;

    // обмен любезностями или ввод данных
    std::cout << "Enter dividend: ";
    std::cin >> remainder;
    std::cout << "Enter divisor: ";
    std::cin >> divisor;

    // переменные в которых будет хранится результат от встроенного деления и взятия остатка
    int real_res = 0;
    int real_rem = 0;

    // проверяем делитель на равенство 0
    if (divisor == 0) {
        // в случае 0 посылаем в плохую концовку программы
        goto badending;
    }

    // вычисляем правильный результат
    real_res = remainder / divisor;
    real_rem = remainder % divisor;

    //начинаем шаманить

    // если делимое меньше 0 остаток должен быть тоже меньше 0 и частное должно быть отрицательным
    if (remainder < 0) {
        // меняем знак делимого
        remainder = 0 - remainder;
        negative_remainder = true;
        delta = 0 - delta;
    }

    // если делитель меньше 0 частное должно быть отрицательным только если делитель не отрицательный
    if (divisor < 0) {
        // меняем знак делителя
        divisor = 0 - divisor;
        delta = 0 - delta;
    }

    // если делить нечего пропускаем цикл
    if (divisor > remainder) {
        goto endloop;
    }

    // начинаем цикл деления двух положительных чисел
    loop:
    // собственно итерация деления
    remainder = remainder - divisor;

    // увеличиваем частное на знаковую дельту
    quotient = quotient + delta;

    // пока есть что делить делим
    if (remainder >= divisor) {
        goto loop;
    }

    // конец цикла
    endloop:

    // делаем остаток отрицательным при необходимости
    if (negative_remainder) {
        remainder = 0 - remainder;
    }

    // вывод того что получилось в результате шаманства
    std::cout << "quotient: " << quotient << ", remainder: " << remainder << std::endl;
    // вывод того что должно было получиться
    std::cout << "real quotient: " << real_res << ", real remainder: " << real_rem;
    return 0;

    // плохая концовка с сообщением об ощибке деления на 0
    badending:
    std::cout << "Error, division by zero";
    return 0;
}
