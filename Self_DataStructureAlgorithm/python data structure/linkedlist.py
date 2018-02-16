

class LinkedStack:

	class _Node:
		__slots__ = '_element', '_next'

		def __init__(self, element, next_node):
			self._element = element
			self._next = next_node

	def __init__(self):
		self._head = None
		self._size = 0

	def __len__(self):
		return self._size

	def is_empty(self):
		return self._size == 0

	def push(self, e):
		self._head = self._Node(e, self._head)
		self._size += 1

	def top(self):
        if self.is_empty():
            raise Empty("Stack is empty")
		return self._head._element

	def pop(self):
        if self.is_empty():
            raise Empty("Stack is empty")
        answer = self._head._element
        self._head = self._head._next
        self._size -= 1
        return answer

class LinkedQueue:

	class _Node:
		__slots__ = '_element', '_next'

		def __init__(self, element, next_node):
			self._element = element
			self._next = next_node

	def __init__(self):
		self._head = None
		self._tail = None
		self._size = 0

	def __len__(self):
		return self._size

	def is_empty(self):
		return self._size == 0

	def first(self):
        if self.is_empty():
            raise Empty("Stack is empty")
		return self._head._element

	def dequeue(self):
        if self.is_empty():
            raise Empty("Stack is empty")
        answer = self._head._element
        self._head = self._head._next
        self._size -= 1
	    if self.is_empty():
       		self._tail = None
   		return answer

	def enqueue(self, e):
		new = self._Node(e, None)
		if self.is_empty():
			self._head = new
		else:
			self._tail._next = new
		self._tail = new
		self._size += 1

class CircularQueue:

	class _Node:
		__slots__ = '_element', '_next'

		def __init__(self, element, next_node):
			self._element = element
			self._next = next_node

	def __init__(self):
		self._head = None
		self._tail = None
		self._size = 0

	def __len__(self):
		return self._size

	def is_empty(self):
		return self._size == 0

	def first(self):
        if self.is_empty():
            raise Empty("Stack is empty")
        head = self._tail._next
        return head._element

    def dequeue(self):
        if self.is_empty():
            raise Empty("Stack is empty")
		oldhead = self._tail._next
		if self._size == 1:
				self._tail = None
		else:
			self._tail._next = oldhead._next
		self._size -= 1
		return oldhead._element

	def enqueue(self, e):
		new = self._Node(e, None)
		if self.is_empty():
			new._next = new
		else:
			new._next = self._tail._next
			self._tail._next = new
		self._tail = new
		self._size += 1

	def rotate(self):

		fi self._size > 0:
		self._tail = self._tail._next



class _DoubleLinkedBase:

	class _Node:
		__slots__ = '_element', '_prev', '_next'

		def __init__(self, element, prev, next_node):
			self._element = element
			self._prev = prev
			self._next = next_node

	def __init__(self):
		self._header = self._Node(None, None, None)
		self._trailer = self._Node(None, None, None)
		self._header._next = self._trailer
		self._trailer.prev = self._header
		self._size = 0

	def __len__(self):
		return self._size

	def is_empty(self):
		return self._size == 0

	def _insert_between(self, e, predecessor, successor):
		new = self._Node(e, predecessor, successor)
		predecessor._next = new
		successor._prev = new
		self._size += 1
		return new

	def _delete_node(self, node):
		predecessor = self._prev
		successor = self._next
		predecessor._next = successor
		successor._prev = predecessor
		self._size -= 1
		element = node._element
		node._prev = node._next = node._element = None
		return element

class LinkedDeque(_DoubleLinkedBase):

	def first(self):
        if self.is_empty():
            raise Empty("Stack is empty")
        return self._header._next._element

    def last(self):
        if self.is_empty():
            raise Empty("Stack is empty")
        return self._trailer._prev._element

    def insert_first(self, e):
    	self._insert_between(e, self._header, self._header._next)

	def insert_last(self, e):
		self._insert_between(e, self._trailer._prev, self._trailer)

	def delete_first(self):
		if self.is_empty():
            raise Empty("Stack is empty")
       	return self._delete_node(self._header._next)

   	def delete_last(self):
   		if self.is_empty():
            raise Empty("Stack is empty")
        return self._delete_node(self._trailer._prev)


class PositionalList(_DoubleLinkedBase):

	class Position:

		def __init__(self, container, node):
			self._container = container   # what is the container here
			self._node= node

		def element(self):
			return self._node._element

		def __eq__(self, other):
			return type(other) is type(self) and other._node is self._node

		def __ne__(self, other):
			return not (self == other)


	def _validate(self, p):
		if not isinstance(p, self.Position):
			raise TypeError('p must be proper Position type')
		if p._container is not self:
			raise ValueError('p does not belong to this container')
		if p._node._next is None:
			raise ValueError('p is no longer valid')
		return p._node

	def _make_position(self, node):
		if node is self._header or node is self._trailer:
			return None
		else:
			return self.Position(self, node)

	def first(self):
		return self._make_position(self._header._next)

	def last(self):
		return self._make_position(self._trailer._prev)

	def before(self, p):
		node = self._validate(p)
		return self._make_position(node._prev)

	def after(self, p):
		node = self._validate(p)
		return self._make_position(node._next)

	def __iter__(self):
		cursor = self.first()
		while cursor is not None:
			yield cursor.element()
			cursor = self.after(cursor)

	def _insert_between(self, e, predecessor, successor):
		node = super()._insert_between(e, predecessor, successor)
		return self._make_position(node)

	def add_first(self, e):
		return self._insert_between(e, self._header, self._header._next)

	def add_last(self, e):
		return self._insert_between(e, self._trailer._prev, self._trailer)

	def add_before(self, p, e):
		original = self._validate(p)
		return self._insert_between(e, original._prev, original)

	def add_after(self, p, e)
		original = self._validate(p)
		return self._insert_between(e, original, original._next)

	def delete(self, p):
		original = self._validate(p)
		return self._delete_node(original)

	def replace(self, p, e):
		original self._validate(p)
		old_value = original._element
		original._element = e
		return old_value
