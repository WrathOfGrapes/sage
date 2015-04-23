def getCircleCoordinates(i, n):
    'Get coordinates for i-th vertex in a n-vertexed graph'
    x = cos(i  * 2.0 * pi/ n)
    y = sin(i  * 2.0 * pi/ n)
    return (x,y)

def getCoordsForVertices(graph):
    return {graph.vertices()[i]: getCircleCoordinates(i,len(graph.vertices())) for i in xrange(len(graph.vertices()))}


def graphPlot(graph, marks = [], path = []):
    pic = Graphics()
    dic = getCoordsForVertices(graph)
    for i in graph.vertices():
        if i == path[0]:
            color = 'red'
            thicness = 50
        elif i == path[1]:
            color = 'blue'
            thicness = 50
        else:
            color = 'black'
            thicness = 3
        p = point(dic[i],color = color, size = thicness)
        pic += plot(p)
    for i in graph.edges():
        if i in marks:
            color = 'blue'
            thicness = 3
        else:
            color = 'black'
            thicness = 1
        pic += plot(line([dic[i[0]],dic[i[1]]], color = color, thickness = thicness))
    pic.axes(False)
    return pic

def showGraph(graph, marks = [], path = []):
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
    return edges

def listOfSteps(graph, start,end):
    paths = [[start]]
    marks = []
    pics = [graphPlot(graph,marks,[start,end])]
    while end not in map(lambda x: x[-1],paths) and len(paths)>0:
        paths = itteration(graph,paths,start,end)
        marks = pathToEdge(paths)
        pics += [graphPlot(graph,marks,[start,end])]
    paths = filter(lambda x: x[-1] == end,paths)
    marks = pathToEdge(paths)
    pics += [graphPlot(graph,marks,[start,end])]
    return pics


r = graphs.RandomGNP(3,1)
#r = graphs.RandomTree(15)
for i in listOfSteps(r,0,1):
    show(i)






