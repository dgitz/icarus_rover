//Make: g++ `pkg-config opencv --cflags` camtest.cpp -o camtest `pkg-config opencv --libs`
//Test Camera: guvcview --size=160x120 --format=yuyv

#include <iostream>
//#include <opencv/core/core.hpp>
#include "opencv2/opencv.hpp"
#include <highgui.h>
//#include <opencv2/highgui/highhui.hpp>
using namespace std;
using namespace cv;

int SHOW_IMAGES = 1;
time_t start,end;

int counter = 0;



int main(){
	
        time(&start);
        VideoCapture vc(0);
        //cout << vc.get(CV_CAP_PROP_FRAME_WIDTH) << endl;
        vc.set(CV_CAP_PROP_FRAME_WIDTH,320);
        vc.set(CV_CAP_PROP_FRAME_HEIGHT,240);
        vc.set(CV_CAP_PROP_CONVERT_RGB,false);
        vc.set(CV_CAP_PROP_FPS,60);
        if (!vc.isOpened())
        {
                cout <<"Could Not Start.";
                return 0;
        }
        Mat frame;
        Mat frame2;
        if (SHOW_IMAGES) { namedWindow("camera",1); }
        char key = 'a';
        while(key != 27)
        {
                vc.read(frame);
                cvtColor(frame,frame2,COLOR_BGR2GRAY);
                if (SHOW_IMAGES) {imshow("camera",frame2);}
                time(&end);
                counter++;
                cout << "fps: " << counter/difftime(end,start)  << endl;
                if (SHOW_IMAGES) { key = waitKey(3); }

        }
        destroyAllWindows();       
	return 0;
}
