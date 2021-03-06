# Link to Sage Cloud https://cloud.sagemath.com/projects/bf3fb444-f1b1-49fe-8eaf-7048de5f83c9/files/makeStructure.sagews


def getCircleCoordinates(i, n):
    'Get coordinates for i-th vertex in a n-vertexed graph'
    x = cos(i  * 2.0 * pi/ n)
    y = sin(i  * 2.0 * pi/ n)
    return (x,y)

def getCoordsForVertices(graph):
    return {graph.vertices()[i]: getCircleCoordinates(i,len(graph.vertices())) for i in xrange(len(graph.vertices()))}


def graphPlot(graph, marks = [], path = [], markColor = 'blue'):
    pic = Graphics()
    dic = getCoordsForVertices(graph)
    for i in graph.vertices():
        if i == path[0]:
            color = 'blue'
            thicness = 50
        elif i == path[1]:
            color = 'red'
            thicness = 50
        else:
            color = 'black'
            thicness = 3
        p = point(dic[i],color = color, size = thicness)
        pic += plot(p)
    for i in graph.edges():
        if i in marks:
            color = markColor
            thicness = 3
        else:
            color = 'black'
            thicness = 1
        pic += plot(line([dic[i[0]],dic[i[1]]], color = color, thickness = thicness))
    pic.axes(False)
    return pic

def showGraph(graph, marks = [], path = []):
    '''Draws graph with  vertices ordered on the plane'''
    show(graphPlot(graph, marks, path ))

def itteration(graph, paths, start,end):
    marks = []
    for path in paths:
        for vert in graph.neighbors(path[-1]):
            if vert not in path:
                marks += [path+[vert]]
    return marks

def pathToEdge(paths):
    edges = []
    for j in paths:
        for i in xrange(1,len(j)):
            edges += [(j[i-1],j[i],None)]
            edges += [(j[i],j[i-1],None)]
    return edges

def listOfSteps(graph, start,end):
    'Return list of plots, illustrating the work of algorithm'
    paths = [[start]]
    marks = []
    pics = [graphPlot(graph,marks,[start,end])]
    while end not in map(lambda x: x[-1],paths) and len(paths)>0:
        paths = itteration(graph,paths,start,end)
        marks = pathToEdge(paths)
        pics += [graphPlot(graph,marks,[start,end])]
    paths = filter(lambda x: x[-1] == end,paths)
    for path in paths:
        marks = pathToEdge([path])
        pics += [graphPlot(graph,marks,[start,end],markColor='red')]
    return pics




def animateGraph(graph, start, end):
    'Creates animation of algorithm for a graph'
    return animate(listOfSteps(graph,start,end))

#r = graphs.RandomGNP(14,0.25)
#while not r.is_connected():
#    r = graphs.RandomGNP(14,0.25)
#a = animateGraph(r,2, 8)
#a.show()

@interact
def graphInteract(\
                 verticesNum = slider(1,100,1, label = 'Vertices'),\
                 edgeDensity = slider(0,1,0.01, label = 'Edge density'),\
                 seed=input_box(label="Seed", type=int, default = 1),\
                 FPS = slider(1,10,1,label = 'FPS')):
    graph = graphs.RandomGNP(verticesNum,edgeDensity, seed = seed)
    animation = animateGraph(graph, 0, verticesNum//2)
    animation.show(1.0/FPS)
