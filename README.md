# Polysec

<p align="center">
<img src="https://www.whoop.ee/assets/img/polysec.svg" alt="Polysec logo">
</p>

<p align="center">
<a href="https://github.com/dknight/polysec/releases"><img alt="GitHub Release" src="https://img.shields.io/github/v/release/dknight/polysec"></a>
<a href="https://github.com/dknight/polysec/actions/workflows/test.yml"><img src="https://github.com/dknight/polysec/actions/workflows/test.yml/badge.svg" alt="Tests"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
</p>

*Polysec* is a framework-agnostic Lua library for detecting intersections and collisions between polygons, circles and rectangles. It provides an efficient algorithm for polygonal intersection detection, making it suitable for the collision handling. While Polysec is independent of any specific framework, it is framework-agnostic.

## Features

- Detect point belongs to polygon, circle or rectangle.
- Detect collision of rectangles, circles and polygons.
- Measure distance between two points.
- Checks that two point are equal (have same coordinates).

![Polygon intersection animated demonstration in GIF format](https://www.whoop.ee/assets/img/polysec-demo.gif)


## Weiler-Athethon algorithm shortly

Under the hood *Polysec* uses the [Weiler-Athethon algorithm](https://en.wikipedia.org/wiki/Weiler%E2%80%93Atherton_clipping_algorithm) to detect polygon intersections.

### Algorithm Preconditions

Before applying the algorithm to a polygon, the following conditions must be met:

- Polygons must be oriented in a clockwise direction.
- Polygons must not be self-intersected (i.e., they should not be re-entrant).

### Algorithm Steps

Given polygon A (clipping region) and polygon B (subject region) to be clipped, the algorithm proceeds as follows:

1. List the vertices of both polygon A and polygon B.
2. Classify each vertex of polygon B as either inside or outside of polygon A.
3. Identify all intersection points between the polygons and insert them into both vertex lists, ensuring they are at the intersection points.
4. Determine "inbound" intersections, where the vector from an intersection to the next vertex of polygon B originates inside the clipping region A.
5. Traverse the lists, following each intersection in a clockwise direction until returning to the starting position.

### Handling no intersection cases

If no intersections are found, one of the following must be true:

- Polygon A is entirely inside Polygon B.
- Polygon B is entirely inside Polygon A.
- Polygons A and B do not overlap.

![Illustration of the Weiler-Athethon algorithm](https://www.whoop.ee/assets/img/weiler-Athethon-algorithm-01.svg)

## Usage

```lua
local polysec = require("init")
local polygon = polysec.polygon
local point = polysec.point

local square = polygon.new(
	point.new(100, 150),
	point.new(200, 150),
	point.new(200, 250),
	point.new(100, 250)
)
local triangle = polygon.new(
    point.new(125, 125),
    point.new(62.5, 225),
    point.new(25, 125)
)

-- If polygons are not overlapping, nil and false are returned. Otherwise
-- returns clipping polygon and true.
local clip, overlaps = polygon.overlaps(square, triangle)

print("Is overlapping: " .. tostring(overlaps))
if clip ~= nil then
	for i, p in ipairs(clip) do
		print("Point " .. i .. ": {x = " .. p.x .. ", y = " .. p.y .. "}")
	end
end
-- Output:
--[[
Is overlapping: true
Point 1: {x = 109.375, y = 150.0}
Point 2: {x = 100.0, y = 165.0}
Point 3: {x = 100, y = 150}
--]]
```

## Orthogonal usage

> [!TIP]
> If you're working exclusively with axis-aligned rectangles, use the `orthogonal` module for a simpler and more efficient algorithm. For non-rectangular polygons, opt for the `polygon` module.

```lua
local polysec = require("init")
local orthogonal = polysec.orthogonal

local rect = orthogonal.rectangle.new(0, 0, 100, 100)
orthogonal.contain(rect, point.new(50, 50)) --> true
orthogonal.overlap(rect, orthogonal.rectangle.new(50, 50, 75, 75)) --> true
```

## Running demos

Demos are written in [Löve2D Framework](https://love2d.org/). To run demos
Löve2D should be installed on your machine.

Use relative paths for demos; this keeps the import path correct.

```shell
love ./demos/point-inside
love ./demos/polygon-intersection
love ./demos/rectangle-intersection
love ./demos/circle-intersection
```

## Tests

Unit-tests are performed using [Laura testing framework](https://github.com/dknight/laura/).
Linting is performed using [luacheck](https://github.com/mpeterv/luacheck).

Unit tests

```shell
laura .
```
Lint (code quality)

```shell
luacheck src test
```

Run everything with `make` software

```shell
make lint test
```

## API

### Types

- `Point [number, number]`
- `Rectangle number[]`
- `Polygon number[]`
- `Circle number[]`
- `Shape Rectangle | Polygon | Circle | {kind: Kind}`

### Modules

#### `point`

- `new(x: number, y: number): Point`<br>
  Creates a new point instance with x and y coordinates.
- `distanceTo(p: Point, q: Point): number`<br>
  Computes the distance between two points.
- `areEqual(p: Point, q: Point): number`<br>
  Checks that two points have same coordinates.

#### `rectangle`

- `new(x1: number, y1: number, x2; number, y2: number): Rectangle`<br>
- `new(p: Point, q: Point): Rectangle`<br>
  Creates a new rectangle instance.
- `toList(rect: Rectangle): number`<br>
  Converts the rectangle to the array of numbers.

#### `polygon`

- `new(...points: Point[]): Polygon`<br>
  Creates a new polygon instance.
- `add(...points: Point[]): nil`<br>
  Adds point(s) to the polygon.
- `toList(): number[]`<br>
  Converts polygon to the form of array \[x1, y1, x2, y2, y3, y3, ..., xN, yN\].

#### `circle`

- `new(x: number, y: number, r: number): Circle`<br>
- `new(p: Point, r: number): Circle`<br>
  Creates a new circle instance.
- `toList(circle: Circle): number`<br>
  Converts the circle to the array of numbers.

#### `contian`

- `contain(s: Shape, p: Point): boolean`<br>
  Checks is the point inside a shape.
  For polygon using the winding number method.

#### `overlap`

- `overlap(s: Shape, t: Shape): boolean, Shape?`<br>
  Checks overlapping of two shapes.

#### `helpers`

- `closeTo(a: number, b: number): boolean`<br>
  Helper function for float equality comparison.
- `isCircle(s: Shape): boolean`<br>
  Checks that shape is a circle.
- `isPolygon(s: Shape): boolean`<br>
  Checks that shape is a polygon.
- `isRectangle(s: Shape): boolean`<br>
  Checks that shape is a rectangle.

#### `orthogonal`

- `rectangle: Rectamgle`<br>
  Same as [`rectangle`](#rectangle)
- `overlap(s: Rectangle t: Rectangle): boolean`<br>
  Checks overlapping of two orthogonal rectangles.
- `contain(r: Rectangle, p: Point): boolean`<br>
  Checks that point is inside orthogonal rectangle.

#### enum `Constant`

- `Epslion: number`<br>
  A very small number, value is `1e-9`.

#### enum `Kind`

- `Rectangle = 0`
- `Polygon = 1`
- `Circle = 2`

## Contribution

Any help is appreciated. Found a bug, typo, inaccuracy, etc.? Please do not
hesitate to create [a pull request](https://github.com/dknight/polysec/pulls)
or submit an [issue](https://github.com/dknight/polysec/issues).

## License

MIT 2025
