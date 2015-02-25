//
//  DrawingModel.swift
//  project2
//
//  Created by Robert Johansen on 2/23/15.
//  Copyright (c) 2015 Robert Johansen. All rights reserved.
//

import UIKit

class DrawingModel {
    
    var color: UIColor = UIColor.clearColor()
    
    struct PointF {
        var x: Float
        var y: Float
    }
    
    struct Color {
        var r: Float
        var g: Float
        var b: Float
        var a: Float
    }
    
    struct PolyLine {
        var points: [PointF]
        var color: Color
    }
    
    private var _polylines: [PolyLine] = []
    
    var polylineCount: Int { return _polylines.count }
    
    func polylineAtIndex(polylineIndex: Int) -> PolyLine {
        return PolyLine(points: [PointF(x: 0.0, y: 0.0), PointF(x: 0.0, y: 0.0), PointF(x: 0.0, y: 0.0)],
            color: Color(r: 1.0, g: 1.0, b: 1.0, a: 1.0))
    }
    
    func addPolyLine(polyline: PolyLine) {
        _polylines.append(polyline)
    }
    
}
