from collections import namedtuple
from math import sqrt
import sys
import random
try:
	import Image
except ImportError:
	from PIL import Image

Point = namedtuple('Point', ('coords', 'n', 'ct'))
Cluster = namedtuple('Cluster', ('points', 'center', 'n'))

def get_points(img):
	points = []
	w, h = img.size
	for count, color in img.getcolors(w * h):
		points.append(Point(color, 3, count))
	return points

rtoh = lambda rgb: '#%s' % ''.join(('%02x' % p for p in rgb))

def colorz(filename, n=3):
	img = Image.open(filename)
	img.thumbnail((200, 200))
	w, h = img.size

	points = get_points(img)
	clusters = kmeans(points, n, 1)
	rgbs = [map(int, c.center.coords) for c in clusters]
	return map(rtoh, rgbs)

def euclidean(p1, p2):
	return sqrt(sum([
		(p1.coords[i] - p2.coords[i]) ** 2 for i in range(p1.n)
		]))

def calculate_center(points, n):
	vals = [0.0 for i in range(n)]
	plen = 0
	for p in points:
		plen += p.ct
		for i in range(n):
			vals[i] += (p.coords[i] * p.ct)
	return Point([(v / plen) for v in vals], n, 1)

def kmeans(points, k, min_diff):
	clusters = [Cluster([p], p, p.n) for p in random.sample(points, k)]

	while 1:
		plists = [[] for i in range(k)]

		for p in points:
			smallest_distance = float('Inf')
			for i in range(k):
				distance = euclidean(p, clusters[i].center)
				if distance < smallest_distance:
					smallest_distance = distance
					idx = i
			plists[idx].append(p)

		diff = 0
		for i in range(k):
			old = clusters[i]
			center = calculate_center(plists[i], old.n)
			new = Cluster(plists[i], center, old.n)
			clusters[i] = new
			diff = max(diff, euclidean(old.center, new.center))

		if diff < min_diff:
			break
	return clusters

def to_value(color):
	color = color[1:]
	return int(color[:1],16)+int(color[2:3],16)+int(color[3:],16)


if __name__ == "__main__":
	fname = sys.argv[1]
	clusters = colorz(fname)
	clusters = sorted(clusters, key=to_value)
	print "bspc config focused_border_color \""+clusters[0]+"\""
	print "bspc config active_border_color \""+clusters[1]+"\""
	print "bspc config normal_border_color \""+clusters[2]+"\""

