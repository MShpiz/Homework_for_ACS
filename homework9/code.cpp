#include <iostream>
#include <queue>
#include <vector>
#include <pthread.h>
#include <random>
#include <unistd.h>
using namespace std;

queue<int> buff;
int writers_done = 0;
int summators_done = 0;
pthread_mutex_t mutex ; // мьютекс для условных переменных
// поток производитель сумматоров блокируется, если не достаточно параметров для суммирования
pthread_cond_t number_added;



void* Writer(void* param) {
   int num = *((int*)param);
   std::random_device random_device;
   mt19937 generator(random_device());
   uniform_int_distribution<> distribution(1, 7);
   int delay = distribution(generator);
   sleep(delay);
   
   pthread_mutex_lock(&mutex) ; //защита операции записи
   cout << "Writer writes: " << num << endl;
   buff.push(num);
   writers_done++;
   pthread_cond_broadcast(&number_added);
   pthread_mutex_unlock(&mutex) ;
    return nullptr;
}

void* Summator(void* param) {
    pair<int, int> numbers = *((pair<int, int>*)param);
    
    std::random_device random_device;
    mt19937 generator(random_device());
    uniform_int_distribution<> distribution(3, 6);
    int delay = distribution(generator);
    sleep(delay);
    
    int result = numbers.first + numbers.second;
    
    pthread_mutex_lock(&mutex) ; //защита операции записи
    buff.push(result);
    cout << "Summator writes result of: " << numbers.first << " + " << numbers.second << " = " << result << endl;
    pthread_cond_broadcast(&number_added);
    summators_done++;
    pthread_mutex_unlock(&mutex) ;
    return nullptr;
}


void* SummFactory(void* param) {
    int total_summators = 0;
    int summ_idx = 0;
    pthread_t summ_thresds[30];
   while (writers_done != 20 || summators_done != total_summators || buff.size() > 1) {
        pthread_mutex_lock(&mutex) ; //защита операции чтения
        //заснуть, если количество занятых ячеек равно нулю
        while (buff.size() < 1) {
            pthread_cond_wait(&number_added, &mutex);
        }

       if (buff.size() > 1) {
            pair<int, int>* param = new pair<int, int>;
            param->first = buff.front();
            buff.pop();
            param->second = buff.front();
            buff.pop();
            pthread_create(&summ_thresds[summ_idx++], NULL, Summator, (void *)(param));
            cout << "Factory created new summator to summ " << param->first << " and " << param->second << endl;
            total_summators++;
       }
        pthread_mutex_unlock(&mutex) ;
        //конец критической секции
        
    }
    return nullptr;
}

int main()
{
    int i ;
    //инициализация мьютексов и условных перменных
    pthread_mutex_init(&mutex, NULL) ; 
    pthread_cond_init(&number_added, NULL);
    
    //запуск писателей
    pthread_t threadW[20] ;
    int writerParams[20];
    cout << "Creating writers: " << endl;
    for (i=0 ; i<20 ; i++) {
        writerParams[i] = i + 1;
        pthread_create(&threadW[i],NULL,Writer, (void*)(writerParams+i)) ;
        cout << "Created writer " << i+1 << endl;
    }
    
    //запуск фабрики сумматоров
    pthread_t factory;
    pthread_create(&factory,NULL,SummFactory, nullptr) ;
    cout << "Summator factory" << endl;
    
    
    pthread_join(factory, nullptr) ;      
        
    int result = buff.back();
    cout << "Result: " << result << endl;
    
    
    return 0;
}
