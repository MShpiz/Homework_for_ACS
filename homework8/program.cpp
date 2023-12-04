#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <pthread.h>


const unsigned int vecSize = 10000000;

const int threadNumber = 4; // ���������� �������

//��������� ������� ��� �������� �������
void* func(void *param) {    //���������� ������������ ��������� �������
    unsigned int shift = vecSize / threadNumber; // �������� � ������ ��� ������ �������
    unsigned int p = (*(unsigned int*)param )*shift;
    double *prod = new double(0);
    for(unsigned int i = p ; i < p+shift ; i++) {
        *prod+= ((double)(i)+1)*(vecSize - i);
    }
    return (void*)prod ;
}

// ������������ ����������� 4 ������
void withThreads() {
    double rez = 0.0 ; //��� ������ �������������� ����������

    pthread_t thread[threadNumber]; // ������ ������
    
    unsigned int A [threadNumber];  // ������ � �������� ������
    
    for(int i = 0; i < threadNumber; ++i) {
        A[i] = i;
    }
    
    clock_t start_time =  clock(); // ��������� �����
    
    //�������� ������� �������� �������
    for (int i=0 ; i<threadNumber ; i++) {

        pthread_create(&thread[i], nullptr, func, (void*)(A+i));
    }
    
    double *sum;
    for (int i = 0 ; i < threadNumber; i++) {    //�������� ���������� ������ �������� �������
        pthread_join(thread[i],(void **)&sum) ;  //� ��������� ���������� �� ����������
        rez += *sum ;
        delete sum ;
    }

    clock_t end_time = clock(); // �������� �����
    
    //����� ����������
    std::cout << "��������� ������������ = " << 
        std::setprecision(40) << rez << "\n" ;

    std::cout << "����� ����� � ������ = " << end_time - start_time << "\n";
}

// ���������� ������ ��� �������
void withoutThreads() {
    double rez = 0.0 ; //��� ������ �������������� ����������
    
    clock_t start_time =  clock(); // ��������� �����
    
    unsigned int i;             // ������� ������������
    for( i = 0 ; i < vecSize; i++) {
        rez += ((double)(i)+1)*(vecSize - i);
    }

    clock_t end_time = clock(); // �������� �����
    
    //����� ����������
    std::cout << "��������� ������������ = " << 
        std::setprecision(40) << rez << "\n" ;

    std::cout << "����� ����� = " << end_time - start_time << "\n";
}

int main() {
    std::cout << "��������� ��������� � 4 ��������" << std::endl;
    withThreads();
    std::cout << " \n\n\n ��������� ��������� � 1 �������" << std::endl;
    withoutThreads();
    
    return 0;
}
