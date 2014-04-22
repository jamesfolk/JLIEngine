#include "MazeCreator.h"
#include "MeshMazeCreator.h"

//#define GetMazeNode(row, column) ((*m_MazeConstruct)[Index2D(row, column)])
#include <string>

#include "ImageFileEditor.h"
#include "btVector2.h"
#include "btVector3.h"

MazeGeneric *MazeCreator::CreateNew(unsigned int row_count, unsigned int column_count, const MazeRenderType type, unsigned int seed){
	MazeGeneric *ret = NULL;
	
	switch (type)
    {
		case MazeRenderType_HTML:
			ret = (MazeGeneric*)(new MazeHTML());
			break;
        case MazeRenderType_PNG:
            ret = (MazeGeneric*)(new MazePNG());
            break;
        case MazeRenderType_Mesh:
            ret = (MazeGeneric*)(new MeshMazeCreator());
            break;
        case MazeRenderType_Texture:
            ret = (MazeGeneric*)(new TextureMazeCreator());
            break;
		default:
			ret = new MazeGeneric();
			break;
	}
	
    btAssert(ret);
	ret->CreateMaze(row_count, column_count, seed);
	
	return ret;
}
MazeCreator::MazeCreator(void){
}
MazeCreator::~MazeCreator(void){
}



MazeGeneric::MazeNode::MazeNode() :
	_data(0),
	m_pNorthNode(NULL),
	m_pEastNode(NULL),
	m_pSouthNode(NULL),
	m_pWestNode(NULL),
	m_ID(0)
{
	has_north_wall = 1;
	has_east_wall = 1;
	has_south_wall = 1;
	has_west_wall = 1;
	
	is_visited = 0;
}
MazeGeneric::MazeNode::MazeNode(const MazeNode &rhs) :
	_data(rhs._data),
	m_pNorthNode(rhs.m_pNorthNode),
	m_pEastNode(rhs.m_pEastNode),
	m_pSouthNode(rhs.m_pSouthNode),
	m_pWestNode(rhs.m_pWestNode),
	m_ID(rhs.m_ID)
{
}

MazeGeneric::MazeNode::~MazeNode(){
	m_pNorthNode = NULL;
	m_pEastNode = NULL;
	m_pSouthNode = NULL;
	m_pWestNode = NULL;
}
MazeGeneric::MazeNode &MazeGeneric::MazeNode::operator=(const MazeGeneric::MazeNode &rhs){
	if(this != &rhs){
		_data = rhs._data;
		m_pNorthNode = rhs.m_pNorthNode;
		m_pEastNode = rhs.m_pEastNode;
		m_pSouthNode = rhs.m_pSouthNode;
		m_pWestNode = rhs.m_pWestNode;
		m_ID = rhs.m_ID;
	}
	return *this;
}
void MazeGeneric::MazeNode::Initialize(const unsigned int _id,
									  MazeGeneric::MazeNode * north_node,
									  MazeGeneric::MazeNode * east_node, 
									  MazeGeneric::MazeNode * south_node, 
									  MazeGeneric::MazeNode * west_node){
	m_ID = _id;
	
	m_pNorthNode = north_node;
	m_pEastNode = east_node;
	m_pSouthNode = south_node;
	m_pWestNode = west_node;
}
void MazeGeneric::MazeNode::BreakWall(const MazeNodeWall wall){
	switch (wall) {
		case MazeNodeWall_NORTH:
			has_north_wall = 0;
			break;
		case MazeNodeWall_EAST:
			has_east_wall = 0;
			break;
		case MazeNodeWall_SOUTH:
			has_south_wall = 0;
			break;
		case MazeNodeWall_WEST:
			has_west_wall = 0;
			break;
		default:
			break;
	}
}
bool MazeGeneric::MazeNode::IsBrokenWall(const MazeNodeWall wall)const {
	switch (wall) {
		case MazeNodeWall_NORTH:
			return (has_north_wall == 0);
		case MazeNodeWall_EAST:
			return (has_east_wall == 0);
		case MazeNodeWall_SOUTH:
			return (has_south_wall == 0);
		case MazeNodeWall_WEST:
			return (has_west_wall == 0);
	}
	return false;
}
void MazeGeneric::MazeNode::Visit(const bool visit){
	if(visit)
		is_visited = 1;
	else
		is_visited = 0;
}
bool MazeGeneric::MazeNode::IsVisited()const {
	return (is_visited == 1);
}
void MazeGeneric::MazeNode::SetIsPartOfSolvedPath(const bool part_of_solved_path){
	if(part_of_solved_path){
		this->is_part_of_solved_path = 1;
	}else{
		this->is_part_of_solved_path = 0;
	}
}
bool MazeGeneric::MazeNode::IsPartOfSolvedPath()const {
	return (is_part_of_solved_path == 1);
}
bool MazeGeneric::MazeNode::operator==(const MazeNode &right)const {
	return (m_ID == right.m_ID);
}
bool MazeGeneric::MazeNode::operator!=(const MazeNode &right)const {
	return !(*this == right);
}
MazeGeneric::MazeNode *const MazeGeneric::MazeNode::GetNorthNode()const {
	return m_pNorthNode;
}
MazeGeneric::MazeNode *const MazeGeneric::MazeNode::GetEastNode()const {
	return m_pEastNode;
}
MazeGeneric::MazeNode *const MazeGeneric::MazeNode::GetSouthNode()const {
	return m_pSouthNode;
}
MazeGeneric::MazeNode *const MazeGeneric::MazeNode::GetWestNode()const {
	return m_pWestNode;
}

unsigned int MazeGeneric::MazeNode::GetID()const {
	return m_ID;
}

MazeNodeType MazeGeneric::MazeNode::GetType()const
{
	int nnode, enode, snode, wnode;
	nnode = (int)!this->IsBrokenWall(MazeNodeWall_NORTH);
	enode = (int)!this->IsBrokenWall(MazeNodeWall_EAST);
	snode = (int)!this->IsBrokenWall(MazeNodeWall_SOUTH);
	wnode = (int)!this->IsBrokenWall(MazeNodeWall_WEST);
	return ((MazeNodeType)( (nnode<<3) | (enode<<2) | (snode<<1) | (wnode<<0) ));
}


MazeGeneric::MazeGeneric() :
	m_RenderType(MazeRenderType_NONE),
	m_NumColumns(0),
	m_NumRows(0),
	m_Maze(NULL),
	m_BeginningID(0),
	m_EndID(0),
	m_IsFoundSolution(false)
{
}
MazeGeneric::MazeGeneric(const MazeGeneric &rhs) :
	m_RenderType(rhs.m_RenderType),
	m_NumColumns(rhs.m_NumColumns),
	m_NumRows(rhs.m_NumRows),
	m_Maze(NULL),
	m_BeginningID(rhs.m_BeginningID),
	m_EndID(rhs.m_EndID),
	m_IsFoundSolution(rhs.m_IsFoundSolution)
{
	if(rhs.m_Maze){
		m_NumRows = rhs.m_NumRows;
		m_NumColumns = rhs.m_NumColumns;
		
		m_Maze = new MazeNode*[m_NumRows];
        btAssert(m_Maze);
		for(unsigned int i = 0; i < m_NumRows; i++)
        {
			m_Maze[i] = new MazeNode[m_NumColumns];
            btAssert(m_Maze[i]);
        }
	}
	
	this->Clone(rhs);
}
MazeGeneric &MazeGeneric::operator=(const MazeGeneric &rhs){
	if(this != &rhs){
		if(m_Maze != NULL){
			for(unsigned int i = 0; i < m_NumRows; i++)
				delete [] m_Maze[i];
			delete [] m_Maze;
		}
		
		m_Maze = new MazeNode*[m_NumRows];
        btAssert(m_Maze);
		for(unsigned int i = 0; i < m_NumRows; i++)
        {
			m_Maze[i] = new MazeNode[m_NumColumns];
            btAssert(m_Maze);
        }
		
		this->Clone(rhs);
	}
	return *this;
}

MazeGeneric::~MazeGeneric(){
	if(m_Maze != NULL){
		for(unsigned int i = 0; i < m_NumRows; i++)
			delete [] m_Maze[i];
		delete [] m_Maze;
	}
}
void MazeGeneric::Clone(const MazeGeneric &rhs){
	//the stack needs to be empty to copy this object.
	btAssert(rhs.m_MazeNodeStack.empty());
	
	for(int row = 0; row < rhs.m_NumRows; row++){
		for(int column = 0; column < rhs.m_NumColumns; column++){
			m_Maze[row][column] = rhs.m_Maze[row][column];
		}
	}
	
	m_RenderType = rhs.m_RenderType;
	m_NumColumns = rhs.m_NumColumns;
	m_NumRows = rhs.m_NumRows;
	m_BeginningID = rhs.m_BeginningID;
	m_EndID = rhs.m_EndID;
	m_IsFoundSolution = rhs.m_IsFoundSolution;
}

MazeRenderType MazeGeneric::GetRenderType()const {
	return m_RenderType;
}

void MazeGeneric::CreateMaze(const unsigned int num_rows, const unsigned int num_columns, unsigned seed)
{
    int size = sizeof(MazeNode);
    
	if(num_rows == 0 || num_columns == 0)
		return;
	
	
	
	unsigned int id = 0;
	unsigned int start_row;
	unsigned int start_column;
	
	if(m_Maze != NULL)
    {
		for(unsigned int i = 0; i < m_NumRows; i++)
			delete [] m_Maze[i];
		delete [] m_Maze;
	}
	
	m_NumRows = num_rows;
	m_NumColumns = num_columns;
    m_Seed = seed;
	
	m_Maze = new MazeNode*[m_NumRows];
    btAssert(m_Maze);
	for(unsigned int i = 0; i < m_NumRows; i++)
    {
		m_Maze[i] = new MazeNode[m_NumColumns];
        btAssert(m_Maze[i]);
    }
	
	for(int row = 0; row < m_NumRows; row++)
    {
		for(int column = 0; column < m_NumColumns; column++)
        {
			GetMazeNode(row, column)->Initialize(id++, 
											   ((row - 1) >= 0)?GetMazeNode(row - 1, column):NULL,
											   ((column + 1) < m_NumColumns)?GetMazeNode(row, column + 1):NULL,
											   ((row + 1) < m_NumRows)?GetMazeNode(row + 1, column):NULL,
											   ((column - 1) >= 0)?GetMazeNode(row, column - 1):NULL);
		}
	}
	
    std::srand(m_Seed);
    
	start_row = (unsigned int)std::rand() % m_NumRows;
	start_column = (unsigned int)std::rand() % m_NumColumns;
    
    
	CarveMaze(GetMazeNode(start_row, start_column));
	
	//GetMazeNode(0, 0)->BreakWall(MazeNodeWall_NORTH);
	//GetMazeNode(m_NumRows - 1, m_NumColumns - 1)->BreakWall(MazeNodeWall_SOUTH);
	
    m_StartColumn = 0;
    m_StartRow = 0;
    m_EndColumn = m_NumColumns - 1;
    m_EndRow = m_NumRows - 1;
    
	m_BeginningID = GetMazeNode(m_StartRow, m_StartColumn)->GetID();
	m_EndID = GetMazeNode(m_EndRow, m_EndColumn)->GetID();
}

void MazeGeneric::SolveMaze(){
	btAssert(m_Maze);
	
	MazeNode *start_node = NULL;
	
	m_IsFoundSolution = false;
	
	for(int row = 0; row < m_NumRows; row++){
		for(int column = 0; column < m_NumColumns; column++){
			GetMazeNode(row, column)->Visit(false);
            GetMazeNode(row, column)->SetIsPartOfSolvedPath(false);
			if(GetMazeNode(row, column)->GetID() == m_BeginningID){
				start_node = GetMazeNode(row, column);
			}
		}
	}
	SolveMaze(start_node);
}
void MazeGeneric::UnSolveMaze(){
	btAssert(m_Maze);
	
	for(int row = 0; row < m_NumRows; row++){
		for(int column = 0; column < m_NumColumns; column++){
			GetMazeNode(row, column)->SetIsPartOfSolvedPath(false);
		}
	}
		
}
void MazeGeneric::getBeginningCoord(unsigned int &row, unsigned int &column)const
{
    row = m_StartRow;
    column = m_StartColumn;
}
void MazeGeneric::getEndCoord(unsigned int &row, unsigned int &column)const
{
    row = m_EndRow;
    column = m_EndColumn;
}

static unsigned int myrandom (int i) { return std::rand()%i;}

void MazeGeneric::CarveMaze(MazeGeneric::MazeNode *node_current){
	btAssert(m_Maze);
	
	/*
	 The depth-first search algorithm of maze generation is frequently implemented using backtracking:
	 Mark the current cell as 'Visited'
	 If the current cell has any neighbours which have not been visited
		Choose randomly one of the unvisited neighbours
		add the current cell to the stack
		remove the wall between the current cell and the chosen cell
		Make the chosen cell the current cell
		Recursively call this function
	 else
		remove the last current cell from the stack
		Backtrack to the previous execution of this function
	 */
	
	MazeNodeVector *mazenode_vector = new MazeNodeVector();
	MazeGeneric::MazeNode *node_next = NULL;
	
	node_current->Visit();
	
	AdjacentNodes(node_current, mazenode_vector);
	
	if(mazenode_vector->size() > 0){
		m_MazeNodeStack.push(node_current);
		
		std::random_shuffle(mazenode_vector->begin(), mazenode_vector->end(), myrandom);
		
		node_next = mazenode_vector->at(0);
		KnockDownWall(node_current, node_next);
		CarveMaze(node_next);
	}else{
		if(m_MazeNodeStack.size() > 0){
			node_next = m_MazeNodeStack.top();
			m_MazeNodeStack.pop();
			CarveMaze(node_next);
		}
	}
    
    delete mazenode_vector;
}

void MazeGeneric::SolveMaze(MazeNode *node_current){
	btAssert(m_Maze);
	
	MazeNodeVector *mazenode_vector = new MazeNodeVector();
	MazeNode *node_next = NULL;
	
	node_current->Visit();
	node_current->SetIsPartOfSolvedPath(true);
	
	if(node_current->GetID() == m_EndID || m_IsFoundSolution){
		m_IsFoundSolution = true;
		return;
	}
	
	AdjacentNodesTraversable(node_current, mazenode_vector);
	
	if(mazenode_vector->size() > 0){
		m_MazeNodeStack.push(node_current);
		
		std::random_shuffle(mazenode_vector->begin(), mazenode_vector->end());
		
		node_next = mazenode_vector->at(0);
		
		SolveMaze(node_next);
	}else{
		node_current->SetIsPartOfSolvedPath(false);
		
		if(m_MazeNodeStack.size() > 0){
			node_next = m_MazeNodeStack.top();
			
			m_MazeNodeStack.pop();
			SolveMaze(node_next);
		}
	}
    
    delete mazenode_vector;
}

void MazeGeneric::KnockDownWall(MazeNode *node1, MazeNode *node2){
	btAssert(m_Maze);
	
	if(node1->GetEastNode() != NULL){
		if(*(node1->GetEastNode()) == *(node2)){
			node1->BreakWall(MazeNodeWall_EAST);
			node2->BreakWall(MazeNodeWall_WEST);
		}
	}
	if(node1->GetWestNode() != NULL){
		if(*(node1->GetWestNode()) == *(node2)){
			node1->BreakWall(MazeNodeWall_WEST);
			node2->BreakWall(MazeNodeWall_EAST);
		}
	}
	if(node1->GetNorthNode() != NULL){
		if(*(node1->GetNorthNode()) == *(node2)){
			node1->BreakWall(MazeNodeWall_NORTH);
			node2->BreakWall(MazeNodeWall_SOUTH);
		}
	}
	if(node1->GetSouthNode() != NULL){
		if(*(node1->GetSouthNode()) == *(node2)){
			node1->BreakWall(MazeNodeWall_SOUTH);
			node2->BreakWall(MazeNodeWall_NORTH);
		}
	}
}
void MazeGeneric::AdjacentNodes(MazeNode *root_node, MazeNodeVector *maze_vector){
	btAssert(m_Maze);
	
	maze_vector->clear();
	
	if(root_node->GetNorthNode() != NULL)
		if(!root_node->GetNorthNode()->IsVisited())
			maze_vector->push_back(root_node->GetNorthNode());
	
	if(root_node->GetSouthNode() != NULL)
		if(!root_node->GetSouthNode()->IsVisited())
			maze_vector->push_back(root_node->GetSouthNode());
	
	if(root_node->GetEastNode() != NULL)
		if(!root_node->GetEastNode()->IsVisited())
			maze_vector->push_back(root_node->GetEastNode());
	
	if(root_node->GetWestNode() != NULL)
		if(!root_node->GetWestNode()->IsVisited())
			maze_vector->push_back(root_node->GetWestNode());
}

void MazeGeneric::AdjacentNodesTraversable(MazeNode *root_node, MazeNodeVector *maze_vector){
	btAssert(m_Maze);
	
	maze_vector->clear();
	
	if(root_node->GetNorthNode() != NULL)
		if(root_node->IsBrokenWall(MazeNodeWall_NORTH))
			if(!root_node->GetNorthNode()->IsVisited())
				maze_vector->push_back(root_node->GetNorthNode());
	
	if(root_node->GetSouthNode() != NULL)
		if(root_node->IsBrokenWall(MazeNodeWall_SOUTH))
			if(!root_node->GetSouthNode()->IsVisited())
				maze_vector->push_back(root_node->GetSouthNode());
	
	if(root_node->GetEastNode() != NULL)
		if(root_node->IsBrokenWall(MazeNodeWall_EAST))
			if(!root_node->GetEastNode()->IsVisited())
				maze_vector->push_back(root_node->GetEastNode());
	
	if(root_node->GetWestNode() != NULL)
		if(root_node->IsBrokenWall(MazeNodeWall_WEST))
			if(!root_node->GetWestNode()->IsVisited())
				maze_vector->push_back(root_node->GetWestNode());
}



MazeHTML::MazeHTML() : 
MazeGeneric()
{
	m_RenderType = MazeRenderType_HTML;
}
MazeHTML::~MazeHTML()
{
	
}
void MazeHTML::Draw()
{
	MazeNode *node;
	
	printf( "<html>\n<body>\n\t" );
    printf( "\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" >" );
	
	for(unsigned int row = 0; row < m_NumRows; row++){
		printf( "\n\t\t\t<tr>" );
		for(unsigned int column = 0; column < m_NumColumns; column++){
			printf( "\n\t\t\t\t<td height=\"8\" width=\"8\">" );
			
			node = GetMazeNode(row, column);
			printf("<img src=\"%s.png\" width=\"8\" height=\"8\" alt=\"%d => %s\" />", cMazeNodeNames[node->GetType()], node->GetID(), cMazeNodeNames[node->GetType()]);
			
			printf( "</td>" );
		}
		printf("\n\t\t\t</tr>\n" );
	}
    printf( "\n\t\t</table>" );
    printf( "\n\t</body>\n</html>" );
}
std::string MazeHTML::getHTMLText()
{
    std::string ret = "";
	MazeNode *node;
    char buffer[256] = "";
	
	sprintf(buffer, "<html>\n<body>\n\t" );
    ret += buffer;
    sprintf(buffer, "\n\t\t<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" >" );
	ret += buffer;
    
	for(unsigned int row = 0; row < m_NumRows; row++){
		sprintf(buffer, "\n\t\t\t<tr>" );
        ret += buffer;
		for(unsigned int column = 0; column < m_NumColumns; column++){
			sprintf(buffer, "\n\t\t\t\t<td height=\"8\" width=\"8\">" );
            ret += buffer;
			
			node = GetMazeNode(row, column);
			sprintf(buffer,"<img src=\"%s.png\" width=\"8\" height=\"8\" alt=\"%d => %s\" />", cMazeNodeNames[node->GetType()], node->GetID(), cMazeNodeNames[node->GetType()]);
            ret += buffer;
			
			sprintf(buffer, "</td>" );
            ret += buffer;
		}
		sprintf(buffer, "\n\t\t\t</tr>\n" );
        ret += buffer;
	}
    sprintf(buffer, "\n\t\t</table>" );
    ret += buffer;
    sprintf(buffer, "\n\t</body>\n</html>" );
    ret += buffer;
    
    return ret;
}
void MazeHTML::writeContent(const std::string data_to_write)
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/maze.html",
                          documentsDirectory];
    //create content - four lines of text
    NSString *content = [NSString stringWithFormat:@"%s", data_to_write.c_str()];
    
    //save content to the documents directory
    [content writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
}
void MazeHTML::displayContent()
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/maze.html",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    //use simple alert from my library (see previous post for details)
    UIAlertView* alert;
    alert = [[UIAlertView alloc] initWithTitle:@"maze.html" message:content delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    NSLog(@"%@", content);
    
}



TextureMazeCreator::TextureMazeCreator() :
m_pMaze(new ImageFileEditor()),
m_pBall(new ImageFileEditor()),
m_pBlank(new ImageFileEditor()),
m_pBallMaze(new ImageFileEditor()),
m_NodeWidth(0),
m_NodeHeight(0),
m_NodeBits(0),
m_LastPosition(new btVector2(0.0f, 0.0f)),
m_ExtendsTile(new btVector3(0.0f, 0.0f, 0.0f)),
m_ExtendsBoard(new btVector3(0.0f, 0.0f, 0.0f))
{
    m_RenderType = MazeRenderType_Texture;
    
    std::string extension("png");
    
    for (int i = 0; i < MazeNodeType_Amount; i++)
    {
        m_pMazeNodes[i] = new ImageFileEditor();
        m_pMazeNodes[i]->load(std::string(cMazeNodeNames[i]) + "." + extension);

        m_pSolvedMazeNodes[i] = new ImageFileEditor();
        m_pSolvedMazeNodes[i]->load(std::string(cMazeNodeNames[i]) + "_solved." + extension);
    }
    m_pBall->load("BALL.png");
    m_pBlank->load("BLANK.png");
}

TextureMazeCreator::~TextureMazeCreator()
{
    for (int i = 0; i < MazeNodeType_Amount; i++)
    {
        delete m_pSolvedMazeNodes[i];
        delete m_pMazeNodes[i];
    }
    
    delete m_ExtendsBoard;
    delete m_ExtendsTile;
    delete m_LastPosition;
    delete m_pBallMaze;
    delete m_pBlank;
    delete m_pBall;
    delete m_pMaze;
}

void TextureMazeCreator::Draw()
{
    MazeNode *node = NULL;
    
    m_pMaze->load(m_pMazeNodes[0]->getWidth() * 45,
                  m_pMazeNodes[0]->getHeight() * 45,
                  m_pMazeNodes[0]->getNumBits());
    
    m_pBallMaze->load(m_pMazeNodes[0]->getWidth() * 45,
                      m_pMazeNodes[0]->getHeight() * 45,
                      m_pMazeNodes[0]->getNumBits());
    
//    m_pMaze->load(2048,
//                  2048,
//                  m_pMazeNodes[0]->getNumBits());
    
    size_t x = 0;
    size_t y = 0;
    //size_t x_offset = (45 - GetNumColumns()) * m_pMazeNodes[0]->getWidth();
    //size_t y_offset = (45 - GetNumRows()) * m_pMazeNodes[0]->getHeight();
    
    unsigned int row, column;
    
    for(row = 0; row < m_NumRows; row++)
    {
		for(column = 0; column < m_NumColumns; column++)
        {
            node = GetMazeNode(row, column);
            
            x = ((m_NumColumns - 1) - (column)) * m_pMazeNodes[0]->getWidth();
            y = (row) * m_pMazeNodes[0]->getHeight();
            
            //x += x_offset;
            //y += y_offset;
            
            if(node->IsPartOfSolvedPath())
            {
                m_pSolvedMazeNodes[node->GetType()]->draw(x, y, *m_pMaze);
            }
            else
            {
                m_pMazeNodes[node->GetType()]->draw(x, y, *m_pMaze);
            }
            m_pBlank->draw(x, y, *m_pBallMaze);
		}
	}
    
    getBeginningCoord(row, column);
    x = ((m_NumColumns - 1) - (column)) * m_pMazeNodes[0]->getWidth();
    y = (row) * m_pMazeNodes[0]->getHeight();
    m_pBall->draw(x, y, *m_pBallMaze);
    
    m_pMaze->reload();
    m_pBallMaze->reload();
}

void TextureMazeCreator::DrawCurrentPosition(const btVector2 &pos)
{
    
    //printf("(%f, %f)\n", m_ExtendsBoard->x() - pos.x(), pos.y());
    
    btVector2 scaled_pos((((m_ExtendsTile->x() * (GetNumColumns())) * (m_ExtendsBoard->x() - pos.x())) / m_ExtendsBoard->x()),
                         (((m_ExtendsTile->z() * (GetNumRows())) * (pos.y())) / m_ExtendsBoard->z()));
    
    printf("(%f, %f)\n", scaled_pos.x(), scaled_pos.y());
    
    m_pMaze->drawLine(*m_LastPosition, scaled_pos, btVector4(0,1,0,1));
    
    
    
    *m_LastPosition = scaled_pos;
}

void TextureMazeCreator::setStartPosition(const btVector2 &pos)
{
    m_LastPosition->setX(m_ExtendsBoard->x() - pos.x());
    m_LastPosition->setY(pos.y());
}

void TextureMazeCreator::setMeshMazeTileHalfExtends(const btVector3 &halfExtends)const
{
    *m_ExtendsTile = halfExtends * 2.0f;
}

void TextureMazeCreator::setMeshMazeBoardHalfExtends(const btVector3 &halfExtends)const
{
    *m_ExtendsBoard = halfExtends * 2.0f;
}

float TextureMazeCreator::getMiniMapScale()const
{
    //btVector2 minimapExtends(GetNumColumns() * 32, GetNumRows() * 32);
    float minimapWidth = GetNumColumns() * 32;
    float meshmapWidth = m_ExtendsBoard->x();
    
    return (minimapWidth / meshmapWidth);
    
    
}

ImageFileEditor *TextureMazeCreator::getMazeImageFileEditor()const
{
    return m_pMaze;
}

ImageFileEditor *TextureMazeCreator::getBallImageFileEditor()const
{
    return m_pBallMaze;
}

btVector2 TextureMazeCreator::getBoardDimensions()const
{
    return btVector2(m_pMazeNodes[0]->getWidth() * GetNumColumns(),
                     m_pMazeNodes[0]->getHeight() * GetNumRows());
}





MazePNG::MazePNG()
{
    m_RenderType = MazeRenderType_PNG;
}
MazePNG::~MazePNG()
{
    
}

static void saveImage(UIImage *image, NSString *imageName, NSString *extension, NSString *directoryPath)
{
//-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

static UIImage *getImageFromURL(NSString *fileURL)
{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

void MazePNG::Draw()
{
    MazeNode *node = NULL;
    unsigned int _id = 0;
    MazeNodeType type = MazeNodeType_0000;
    
	for(unsigned int row = 0; row < m_NumRows; row++)
    {
		for(unsigned int column = 0; column < m_NumColumns; column++)
        {
            node = GetMazeNode(row, column);
            type = node->GetType();
            _id = node->GetID();
		}
	}
}


