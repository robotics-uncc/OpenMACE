#ifndef BOUNDARY_LIST_H
#define BOUNDARY_LIST_H

#include "common/common.h"

#include "base/geometry/polygon_cartesian.h"
#include "base/geometry/polygon_2DG.h"

#include "boundary_key.h"

using namespace mace::pose;
using namespace std;

MACE_CLASS_FORWARD(BoundaryList);

namespace BoundaryItem {

typedef std::pair<int, BOUNDARYTYPE> BoundaryMapPair;

}

namespace std {

  template <>
  struct hash<BoundaryItem::BoundaryMapPair>
  {
    std::size_t operator()(const BoundaryItem::BoundaryMapPair& k) const
    {
      using std::size_t;
      using std::hash;
      using std::string;

      // Compute individual hash values for first,
      // second and third and combine them using XOR
      // and bit shifting:

      return ((hash<int>()(k.first)
               ^ (hash<int>()((int)k.second) << 1)) >> 1);
    }
  };

}

namespace BoundaryItem {

class BoundaryList
{
public:
    enum BoundaryListState{
        COMPLETE,
        INCOMPLETE
    };

    struct BoundaryListStatus{
        BoundaryListState state;
        std::vector<int> remainingItems;
    };

public:
    BoundaryList();
    BoundaryList(const BoundaryList &rhs);

public:
    void initializeBoundary(const unsigned int &size);
    void clearQueue();
    void appendVertexItem(const Abstract_CartesianPosition* vertexItem);
    void replaceVertexItemAtIndex(const Abstract_CartesianPosition* vertexItem, const unsigned int &index);
    //Ken fix this above, will memory leak

    CartesianPosition_2D getBoundaryItemAtIndex(const unsigned int &index) const;

    size_t getQueueSize() const;

    BoundaryList::BoundaryListStatus getBoundaryListStatus() const;

public:

    mace::geometry::Polygon_Cartesian getBoundary() {
        return boundingPolygon;
    }

    void setBoundary(const mace::geometry::Polygon_Cartesian &boundary) {
        boundingPolygon = boundary;
    }

public:
    BoundaryList& operator = (const BoundaryList &rhs)
    {
        this->boundingPolygon = rhs.boundingPolygon;
        return *this;
    }

    bool operator == (const BoundaryList &rhs) const{
        if(this->boundingPolygon != rhs.boundingPolygon){
            return false;
        }
        return true;
    }

    bool operator != (const BoundaryList &rhs) const{
        return !(*this == rhs);
    }

private:

public:
    mace::geometry::Polygon_Cartesian boundingPolygon;

public:
    friend std::ostream& operator<<(std::ostream& os, const BoundaryList& t);
};

} //end of namespace MissionItem
#endif // BOUNDARY_LIST_H
