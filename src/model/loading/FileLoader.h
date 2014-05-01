//
//  FileLoader.h
//  MazeADay
//
//  Created by James Folk on 4/30/14.
//  Copyright (c) 2014 JFArmy. All rights reserved.
//

#ifndef __MazeADay__FileLoader__
#define __MazeADay__FileLoader__

#include "AbstractSingleton.h"
#include <string>

class FileLoader : public AbstractSingleton<FileLoader>
{
    friend class AbstractSingleton;
    
    FileLoader(){}
    virtual ~FileLoader(){}
public:
    
    std::string getFilePath(const std::string &file)const;
    std::string getResourcePath()const;
    std::string getFileContents(const std::string &file)const;
    std::string getFileExtension(const std::string &file)const;
    std::string getFileName(const std::string &file)const;
    
};

#endif /* defined(__MazeADay__FileLoader__) */
