#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <pthread.h>


const unsigned int vecSize = 10000000;

const int threadNumber = 4; // Количество потоков

//стартовая функция для дочерних потоков
void* func(void *param) {    //вычисление произведения элементов вектора
    unsigned int shift = vecSize / threadNumber; // Смещение в потоке для начала массива
    unsigned int p = (*(unsigned int*)param )*shift;
    double *prod = new double(0);
    for(unsigned int i = p ; i < p+shift ; i++) {
        *prod+= ((double)(i)+1)*((double)(vecSize - i));
    }
    return (void*)prod ;
}

// подпрограмма запускающая 4 потока
void withThreads() {
    double rez = 0.0 ; //для записи окончательного результата

    pthread_t thread[threadNumber]; // массив тредов
    
    unsigned int A [threadNumber];  // массив с номерами тредов
    
    for(int i = 0; i < threadNumber; ++i) {
        A[i] = i;
    }
    
    clock_t start_time =  clock(); // начальное время
    
    //создание четырех дочерних потоков
    for (int i=0 ; i<threadNumber ; i++) {

        pthread_create(&thread[i], nullptr, func, (void*)(A+i));
    }
    
    double *sum;
    for (int i = 0 ; i < threadNumber; i++) {    //ожидание завершения работы дочерних потоков
        pthread_join(thread[i],(void **)&sum) ;  //и получение результата их вычислений
        rez += *sum ;
        delete sum ;
    }

    clock_t end_time = clock(); // конечное время
    
    //вывод результата
    std::cout << "Векторное произведение = " << 
        std::setprecision(40) << rez << "\n" ;

    std::cout << "Время счета и сборки = " << end_time - start_time << "\n";
}

// выполнение задачи без потоков
void withoutThreads() {
    double rez = 0.0 ; //для записи окончательного результата
    
    clock_t start_time =  clock(); // начальное время
    
    unsigned int i;             // считаем произведения
    for( i = 0 ; i < vecSize; i++) {
        rez += ((double)(i)+1)*((double)(vecSize - i));
    }

    clock_t end_time = clock(); // конечное время
    
    //вывод результата
    std::cout << "Векторное произведение = " << 
        std::setprecision(40) << rez << "\n" ;

    std::cout << "Время счета = " << end_time - start_time << "\n";
}

int main() {
    std::cout << "Запускаем программу с 4 потоками" << std::endl;
    withThreads();
    std::cout << " \n\n\n Запускаем программу с 1 потоком" << std::endl;
    withoutThreads();
    
    return 0;
}
