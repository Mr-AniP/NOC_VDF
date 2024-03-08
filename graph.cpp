//This is testing code used to generate all possible paths between any 2 nodes

#include <iostream>
#include<bits/stdc++.h>
using namespace std;

void printPath(const vector<int>& path) {
    for (int node : path) {
        cout << node << " ";
    }
    cout << endl;
}

void findPaths(const vector<vector<int>>& adjacencyList, int source, int destination) {
    queue<vector<int>> bfsQueue;
    vector<int> path;
    path.push_back(source);
    bfsQueue.push(path);

    while (!bfsQueue.empty()) {
        path = bfsQueue.front();
        bfsQueue.pop();
        int last = path.back();

        if (last == destination) {
            printPath(path);
        }

        const vector<int>& adjacentNodes = adjacencyList[last];

        for (int i = 0; i < adjacentNodes.size(); i++) {
            if (find(path.begin(), path.end(), adjacentNodes[i]) == path.end()) {
                vector<int> newPartialPath = path;
                newPartialPath.push_back(adjacentNodes[i]);
                bfsQueue.push(newPartialPath);
            }
        }
    }
}

int main() {
    // Example usage
    vector<vector<int>> adjacencyList = {
         
        {0,1,2},    // Node 0 is adjacent to its processor and nodes 1,3
        {1,0,3},  // Node 1 is adjacent to its processor and nodes 0,2,4
        {2,0,3},    // Node 2 is adjacent to its processor and nodes 1,5
        {3,1,2}  // Node 3 is adjacent to its processor and nodes 0,4,6
        // {4,1,3,5,7},// Node 4 is adjacent to its processor and nodes 1,3,5,7            
        // {5,2,4,8},  // Node 5 is adjacent to its processor and nodes 2,4,8
        // {6,3,7},    // Node 6 is adjacent to its processor and nodes 3,7
        // {7,4,6,8},  // Node 7 is adjacent to its processor and nodes 4,6,8
        // {8,5,7}     // Node 8 is adjacent to its processor and nodes 5,7
    };



    for(int i = 0; i <= 3 ; i++) {
        for(int j = 0; j <= 3; j++) {
            cout << "Paths from " << i << " to " << j << ":" << endl;
            findPaths(adjacencyList, i, j);
        }
    }
    

    return 0;
}
