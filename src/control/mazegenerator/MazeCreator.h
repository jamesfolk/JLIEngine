#ifndef MAZECREATOR_H
#define MAZECREATOR_H

//#include <utility>
//#include <map>
//#include <string.h>
//#include <vector>
//#include <list>
//#include <algorithm>
//#include <stack>

#include "btScalar.h"
#include <vector>
#include <stack>
#include "AbstractSingleton.h"

//#define MAZE_NODE(row, column) (&m_Maze[row][column])

class MazeGeneric;
class MazeNode;
class MazeHasher;
class MazeCreator;

class MazeHTML;

typedef enum MazeRenderType_e{
	MazeRenderType_NONE,
	MazeRenderType_GENERIC,
	MazeRenderType_HTML,
    MazeRenderType_Mesh,
    MazeRenderType_PNG,
    MazeRenderType_Texture
}MazeRenderType;

typedef enum MazeNodeWall_e{
	MazeNodeWall_NONE,
	MazeNodeWall_NORTH,
	MazeNodeWall_EAST,
	MazeNodeWall_SOUTH,
	MazeNodeWall_WEST,
	MazeNodeWall_MAX
}MazeNodeWall;
/*
 0000
 0001
 0010
 0011
 
 0100
 0101
 0110
 0111
 
 1000
 1001
 1010
 1011
 
 1100
 1101
 1110
 1111
 */


//clock-wise existance of walls
//starting from the north wall.
//0 = no wall
//1 = wall
typedef enum MazeNodeType_e {
	MazeNodeType_0000 = 0x0,
	MazeNodeType_0001 = 0x1,
	MazeNodeType_0010 = 0x2,
	MazeNodeType_0011 = 0x3,
	MazeNodeType_0100 = 0x4,
	MazeNodeType_0101 = 0x5,
	MazeNodeType_0110 = 0x6,
	MazeNodeType_0111 = 0x7,
	MazeNodeType_1000 = 0x8,
	MazeNodeType_1001 = 0x9,
	MazeNodeType_1010 = 0xA,
	MazeNodeType_1011 = 0xB,
	MazeNodeType_1100 = 0xC,
	MazeNodeType_1101 = 0xD,
	MazeNodeType_1110 = 0xE,
	MazeNodeType_1111 = 0xF,
	MazeNodeType_Amount
} MazeNodeType;

static const char *const cMazeNodeNames[] =
{
	"0000",
	"0001",
	"0010",
	"0011",
	"0100",
	"0101",
	"0110",
	"0111",
	"1000",
	"1001",
	"1010",
	"1011",
	"1100",
	"1101",
	"1110",
	"1111"
};




class MazeCreator : public AbstractSingleton<MazeCreator>
{
    friend class AbstractSingleton;
    
public:
	MazeGeneric *CreateNew(unsigned int row_count, unsigned int column_count, const MazeRenderType type, unsigned int seed);
    
private:
	MazeCreator();
	MazeCreator(const MazeCreator &rhs){}
	MazeCreator &operator=(const MazeCreator &rhs){return *this;}
	virtual ~MazeCreator();
};



class MazeGeneric{
protected:
	class MazeNode
    {
	public:
		MazeNode();
		MazeNode(const MazeNode &rhs);
		virtual ~MazeNode();
		MazeNode &operator=(const MazeNode &rhs);
		
		void Initialize(const unsigned int _id, MazeNode * north_node, MazeNode * east_node, MazeNode * south_node, MazeNode * west_node);
		void BreakWall(const MazeNodeWall wall);
		bool IsBrokenWall(const MazeNodeWall wall)const ;
		
		void Visit(const bool visit = true);
		bool IsVisited()const ;
		
		void SetIsPartOfSolvedPath(const bool part_of_solved_path);
		bool IsPartOfSolvedPath()const ;
		
		bool operator==(const MazeNode &right)const ;
		bool operator!=(const MazeNode &right)const ;
		
		MazeNode *const GetNorthNode()const ;
		MazeNode *const GetEastNode()const ;
		MazeNode *const GetSouthNode()const ;
		MazeNode *const GetWestNode()const ;
		
		unsigned int GetID()const ;
		
		MazeNodeType GetType()const;
        
        
	private:
		MazeNode *m_pNorthNode;
		MazeNode *m_pEastNode;
		MazeNode *m_pSouthNode;
		MazeNode *m_pWestNode;
		
		unsigned long long int m_ID;
		
		//TODO: Make generic number of walls.
		union
        {
			struct
            {
				unsigned int has_north_wall : 1;
				unsigned int has_east_wall : 1;
				unsigned int has_south_wall : 1;
				unsigned int has_west_wall : 1;
				
				unsigned int is_visited : 1;
				
				unsigned int is_part_of_solved_path : 1;
				
				unsigned int _unused : 26;
			};
			unsigned int _data;
		};
	};
	
	typedef std::vector<MazeGeneric::MazeNode*> MazeNodeVector;
	typedef std::stack<MazeGeneric::MazeNode*> MazeNodeStack;
	
public:
	MazeGeneric();
	MazeGeneric(const MazeGeneric &rhs);
	MazeGeneric &operator=(const MazeGeneric &rhs);
	virtual ~MazeGeneric();
private:
	void Clone(const MazeGeneric &rhs);
public:
	MazeRenderType GetRenderType()const ;
	
	void CreateMaze(const unsigned int num_rows, const unsigned int num_columns, unsigned seed = time(0));

    SIMD_FORCE_INLINE MazeNode*	GetMazeNode(const unsigned int row, const unsigned int column)
    {
        btAssert(row<m_NumRows);
        btAssert(column<m_NumColumns);
        return &m_Maze[row][column];
    }
    SIMD_FORCE_INLINE const MazeNode*	GetMazeNode(const unsigned int row, const unsigned int column) const
    {
        btAssert(row<m_NumRows);
        btAssert(column<m_NumColumns);
        return &m_Maze[row][column];
    }
    
	unsigned int GetNumRows()const{return m_NumRows;}
	unsigned int GetNumColumns()const{return m_NumColumns;}
    unsigned int GetSeed()const{return m_Seed;}
    
	virtual void Draw() {}
	
	void SolveMaze();
	void UnSolveMaze();
    
    void getBeginningCoord(unsigned int &row, unsigned int &column)const;
    void getEndCoord(unsigned int &row, unsigned int &column)const;
protected:
	MazeRenderType m_RenderType;
	
	unsigned int m_NumColumns;
	unsigned int m_NumRows;
    unsigned int m_Seed;
    
    unsigned int m_StartColumn;
    unsigned int m_StartRow;
    unsigned int m_EndColumn;
    unsigned int m_EndRow;
	
	MazeNode **m_Maze;
	MazeNodeStack m_MazeNodeStack;
	
	unsigned int m_BeginningID;
	unsigned int m_EndID;
	bool m_IsFoundSolution;
private:
	void CarveMaze(MazeNode *node);
	void SolveMaze(MazeNode *node);
	/*
	 TODO: will need to make another class for walls, specifically so that the walls know which are directly next to eachother.
	 */
	void KnockDownWall(MazeNode *node1, MazeNode *node2);
	void AdjacentNodes(MazeNode *root_node, MazeNodeVector *maze_vector);
	void AdjacentNodesTraversable(MazeNode *root_node, MazeNodeVector *maze_vector);
};

class MazeHTML : public MazeGeneric
{
public:
	MazeHTML();
	virtual ~MazeHTML();
	
	void Draw();
public:
    std::string getHTMLText();
    void writeContent(const std::string data_to_write);
    void displayContent();
};

class ImageFileEditor;
class btVector2;
class btVector3;

class TextureMazeCreator : public MazeGeneric
{
public:
	TextureMazeCreator();
	virtual ~TextureMazeCreator();
	
	void Draw();
    
    void DrawCurrentPosition(const btVector2 &pos);
    void setStartPosition(const btVector2 &pos);
    
    void setMeshMazeTileHalfExtends(const btVector3 &halfExtends)const;
    void setMeshMazeBoardHalfExtends(const btVector3 &halfExtends)const;
    
    float getMiniMapScale()const;
    
    ImageFileEditor *getMazeImageFileEditor()const;
    ImageFileEditor *getBallImageFileEditor()const;
    
    btVector2 getBoardDimensions()const;
private:
    ImageFileEditor *m_pMazeNodes[MazeNodeType_Amount];
    ImageFileEditor *m_pSolvedMazeNodes[MazeNodeType_Amount];
    ImageFileEditor *m_pMaze;
    
    ImageFileEditor *m_pBall;
    ImageFileEditor *m_pBlank;
    ImageFileEditor *m_pBallMaze;
    size_t m_NodeWidth;
    size_t m_NodeHeight;
    size_t m_NodeBits;
    btVector2 *m_LastPosition;
    btVector3 *m_ExtendsTile;
    btVector3 *m_ExtendsBoard;
    
                      
public:
//    std::string getHTMLText();
//    void writeContent(const std::string data_to_write);
//    void displayContent();
};

class MazePNG : public MazeGeneric
{
public:
	MazePNG();
	virtual ~MazePNG();
	
	void Draw();
};

#endif
