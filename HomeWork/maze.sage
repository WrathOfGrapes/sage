def generateMaze(N, M): 
    D = (-2,0), (0,2), (2,0), (0,-2)
    Map = {(i,j): 2 - (i % 2 | j % 2) for i in xrange(M) for j in xrange(N)}
    Todo = [(M // int(2) & -2 , N // int(2) & -2)] if random.randrange(2) else [(0, 0), (M - 1, N - 1)]
    for x,y in Todo:
        Map[x,y]=0

    while Todo:
        x,y = Todo.pop(random.randrange(len(Todo)))
        Check = [(dx,dy) for dx,dy in D if 0 <= x+dx < M and 0 <= y+dy < N and Map[x+dx,y+dy]]
        if Check:
            dx,dy = random.choice(Check)
            Todo.extend([(x,y),(x+dx,y+dy)])
            Map[x+dx,y+dy] = Map[x+dx/2,y+dy/2] = 0

    lines = []
    for i in xrange(M):
        lines += ["".join(".#."[Map[i,j]] for j in xrange(N))]
    return lines

def choice(a, b, p):
    ''' p is probability of a '''
    point = uniform(0, 1)
    if point > p:
        return b
    return a

def generate_maze(N):
    maze = N * ['']
    for y in xrange( N):
        for x in xrange( N):
            if (x + y) % 2 == 0:
                maze[y] += '.' if y % 2 == 0 else '#'
            else:
                maze[y] += choice('.', '#', 0.6)
    return maze


def cell (x,y,n, color):
    eps = 1.01/ n
    centerX = x/float(n) *2.0 - 1
    centerY = y/float(n) * -2.0 +1
    return plot(polygon2d([\
                         (centerX - eps,centerY +eps),\
                         (centerX - eps,centerY -eps),\
                         (centerX + eps,centerY -eps),\
                         (centerX + eps,centerY +eps)]\
                         ,color = color))

def drawMaze(maze, color = 'black'):
    n = len(maze[0])
    pic = Graphics()
    for i in xrange(n):
        for j in xrange(n):
            if maze[i][j] == '#':
                pic += cell(j,i,n, color)
    pic.axes(False)
    return pic

def addWalls(maze):
    n = len(maze)
    newMaze = []
    newMaze += ['#'*(n+2)]
    newMaze += ['.'+maze[0] +'#']
    for line in maze[1:-1]:
        newMaze += ['#'+line+'#']
    newMaze += ['#'+maze[-1] +'.']
    newMaze += ['#'*(n+2)]
    return newMaze
    

def getNeighbours(maze, cell):
    rez = []
    for delta in [(0,1),(0,-1),(1,0),(-1,0)]:
        i = delta[0] + cell[0]
        j = delta[1] + cell[1]
        i = max(i,0)
        j = max(j,0)
        if maze[i][j] == '.':
            rez += [(i,j)]
    return rez

def extendPaths(maze,paths):
    viewedCells = reduce(lambda x,y: x + y, paths, [])
    newPaths= []
    for path in paths:
        for cell in getNeighbours(maze,path[-1]):
            if cell not in viewedCells:
                newPaths += [path+[cell]]
                viewedCells += [cell]
    return newPaths

def pathFound(paths, end):
    for path in paths:
        if path[-1] == end :
            return True
    return False

def pathToPlot(maze,paths, visitedColor = 'blue', justAddedColor = 'red'):
    cells = reduce(lambda x,y: x + y, paths, [])
    lastCells = map(lambda x: x[-1], paths)
    plot = Graphics()
    oldCells = []
    newCells = []
    for i in range(len(maze)):
        rowOld = []
        rowNew = []
        for j in range(len(maze[0])):
            if (i,j) in lastCells:
                rowOld += ['.']
                rowNew += ['#']
            elif (i,j) in cells:
                rowOld += ['#']
                rowNew += ['.']
            else:
                rowOld += ['.']
                rowNew += ['.']
        oldCells += [rowOld]
        newCells += [rowNew]
    plot += drawMaze(oldCells,visitedColor) 
    plot += drawMaze(newCells,justAddedColor)
    return plot

def nextFrame(maze, paths):
    length = len(maze)
    if not(pathFound(paths, (length-2,length-1))):
        newPaths = extendPaths(maze, paths)
        plot = pathToPlot(maze,paths)
        plot += drawMaze(maze)
        plot.axes(False)
        return (plot,newPaths)
    elif len(paths)>0:
        plot = pathToPlot(maze,paths[0:1])
        plot += drawMaze(maze)
        plot.axes(False)
        return (plot, [])
    else :
        return (drawMaze(maze),[])

def allFrames(maze):
    frames = []
    paths = [[(1,0)]]
    while len(paths) > 0 :
        a = nextFrame(maze, paths)
        frames += [a[0]]
        paths = a[1]
    return frames


maze = generate_maze(30)
maze = addWalls(maze)
#for i in maze:
#    print i
#show(drawMaze(maze))
#for i in allFrames(maze):
#    show(i)
    
def mazeAnimation(maze):
    return animate(allFrames(maze))

mazeAnimation(maze).show()
