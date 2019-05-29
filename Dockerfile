# To build it :
# docker build -f Dockerfile -t OpenCVImage .
# Then run the container using:
# docker run -ti --rm -p 8080:8080 OpenCVImage


FROM 	ubuntu:16.04

LABEL maintainer="BARRY JARNOUEN LAKBIRI"

WORKDIR /app
COPY src/ /app
EXPOSE 8080

RUN 	apt-get update && \
	apt-get upgrade -y && \
    apt-get install -y apt-utils && \
    apt-get install net-tools && \
    apt-get install -y curl && \
	apt-get install -y --no-install-recommends python python-dev python-pip build-essential cmake git pkg-config libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libatlas-base-dev gfortran libavresample-dev libgphoto2-dev libgstreamer-plugins-base1.0-dev libdc1394-22-dev  && \
    apt-get install -y ant && \
    apt-get install -y default-jre && \
    apt-get install -y default-jdk && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y maven && \
    apt-get install -y g++ 

# making the opencv lib from sources
# cd /opt && \
RUN git clone https://github.com/opencv/opencv.git && \
	cd opencv && \
	git checkout -b 3.4 origin/3.4 && \	
	mkdir build && \
	cd build && \
	cmake -D BUILD_SHARED_LIBS=OFF ..  && \
	make -j8 
# the .so and .jar files for the maven project
RUN mkdir /opencv-java-bin && \
    cp bin/opencv-346.jar lib/libopencv_java346.so /opencv-java-bin/ && \
    cp lib/libopencv_java346.so /usr/lib/x86_64-linux-gnu/

RUN mvn install:install-file -Dfile=./opencv/build/bin/opencv-346.jar -DgroupId=org.opencv -DartefactId=opencv -Dversion=3.4.6 -Dpackaging=jar && \
    mvn clean install
    
RUN java -cp target/fatjar-0.0.1-SNAPSHOT.jar main.Main


CMD ["/bin/bash"]
