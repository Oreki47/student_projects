class Tree:

	class Position:

		def element(self):
			raise NotImplementedError('must be implemented by subclass')

		def __eq__(self, other):
			raise NotImplementedError('must be implemented by subclass')

		def __ne__(self, other):
			raise NotImplementedError('must be implemented by subclass')

	def root(self):
		raise NotImplementedError('must be implemented by subclass')

	def parent(self):
		raise NotImplementedError('must be implemented by subclass')

	def num_childern(self, p):
		raise NotImplementedError('must be implemented by subclass')

	def childern(self, p):
		raise NotImplementedError('must be implemented by subclass')

	def __len__(self):
		raise NotImplementedError('must be implemented by subclass')

	def is_root(self, p):
		return self.root() == p

	def is_leaf(self, p):
		return self.num_childern(p) == 0

	def is_empty(self):
		return len(self) == 0

