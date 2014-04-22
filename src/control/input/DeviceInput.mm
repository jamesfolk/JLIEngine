//
//  DeviceInput.cpp
//  MazeADay
//
//  Created by James Folk on 12/18/13.
//  Copyright (c) 2013 JFArmy. All rights reserved.
//

#include "DeviceInput.h"
//#include "json.h"



void DeviceTouch::pack()
{
//    std::string json_example = "{\"array\": \
//    [\"item1\", \
//     \"item2\"], \
//     \"not an array\": \
//     \"asdf\" \
//     }";
//    
//     // Let's parse it
//     Json::Value root;
//     Json::Reader reader;
//     bool parsedSuccess = reader.parse(json_example,
//                                       root,
//                                       false);
//    
//    if(not parsedSuccess)
//    {
//        // Report failures and their locations
//        // in the document.
//        std::cout<<"Failed to parse JSON"<<std::endl
//        <<reader.getFormatedErrorMessages()
//        <<std::endl;
//    }
//     // Let's extract the array contained
//     // in the root object
//     const Json::Value array = root["array"];
//     // Iterate over sequence elements and
//     // print its values
//     for(unsigned int index=0; index<array.size();
//         ++index)
//    {
//        std::cout<<"Element "
//        <<index
//        <<" in array: "
//        <<array[index].asString()
//        <<std::endl;
//    }
//    
//    
//     // Lets extract the not array element
//     // contained in the root object and
//     // print its value
//     const Json::Value notAnArray =
//     root["not an array"];
//     if(not notAnArray.isNull())
//    {
//        std::cout<<"Not an array: "<<notAnArray.asString()<<std::endl;
//    }
//    
//    
//     // If we want to print JSON is as easy as doing:
//     std::cout<<"Json Example pretty print: "<<std::endl<<root.toStyledString()<<std::endl;
    
    
    
}
char *DeviceTouch::unpack()const
{
    
}


DeviceInput::DeviceInput()
{
}
DeviceInput::~DeviceInput()
{
    
}

DeviceInputTime::DeviceInputTime(double frame):
m_timestamp_frame(frame)//,
//m_timestamp_soundtick([sharedSoundManager getBGMCurrentTime])
{}