# Manju
Manju is a simple object oriented, dynamically typed, functional language that runs on the [Erlang](http://www.erlang.org) virtual machine (BEAM).
Manju's syntax is [Python](https://www.python.org)-like syntax.
Manju also got an influence from [Ruby](https://www.ruby-lang.org) and [Mochi](https://github.com/i2y/mochi).

Its interpreter is written in [Elixir](http://elixir-lang.org). The interpreter translates a program written in Manju to Erlang's AST / bytecode.

## Language Features
### Builtin Types
```python
### Numbers

49  # integer
4.9 # float

### Booleans

True
False

### Atoms

'foo'

### Lists

list = [2, 3, 4]
list2 = [1|list] # => [1, 2, 3, 4]
[1, 2, 3|rest] = list2
rest # => [4]

list.append(5) # => [2, 3, 4, 5]
list # => [2, 3, 4]


list.select(lambda item: item > 1)
    .map(lambda item: item * 2) # => [4, 6]
list # => [2, 4, 5]

# list comprehensions
[n * 2 for n in list] # => [4, 6, 8]

### Tuples

tuple = (1, 2, 3)
tuple.select(lambda item: item > 1)
     .map(lambda item: item * 2) # => [4, 6]

tuple.to_list() # => [1, 2, 3]


### Dicts (Maps)

dict = {'foo': 1, 'bar': 2}
dict2 = dict.put('baz', 3) # => {'foo': 1, 'bar': 2, 'baz': 3}
dict # => {'foo': 1, 'bar': 2}
dict.get('baz', 100) # => 100

### Strings

"Abc"

### Binaries

<<1, 2, 3>>
<<"abc">>
<<1 , 2, x>> = <<1, 2, 3>>
x # => 3

### Anonymous functions

add = lambda x, y: x + y
add(40, 9) # => 49

multiply = lambda x, y:
  x * y

multiply(7, 7) # => 49
```

### Class definition
Car.mj:
```python
class Car:
    def __new__():
        {'name': "foo",
         'speed': 100}
    
    def format(self):
        # self's state is immutable and private.
        # self's state can be referred by "self.attr_name" form.
        self.name.display()
        self.speed.display()

# # usage:
# car = new Car()
# car.format()
```

### Module definition
Enumerable.mj:
```python
def select(self, func):
    _select = lambda item, acc:
        if func.(item):
            acc.append(item)
        else:
            acc

    self.reduce([], _select)


def map(self, func):
    _map = lambda item, acc:
        acc.append(func.(item))
    
    self.reduce([], _map)
```

### Mixing in Modules
SampleList.mj:
```python
class SampleList:
    include Enumerable

    def __new__(items):
        {'items': items}
    
    def reduce(self, acc, func):
        lists::foldl(func, acc, self.items)

# # usage:
# sample_list = new SampleList([1, 2, 3])
# sample_list.select(lambda item: item > 1)
#            .map(lambda item: item * 2}
#            # => [4, 6]
```

### Pipe operator
```python
[1, 2, 3] |> lists::append([4, 5, 6])
          |> lists::append([7, 8, 9])
# => [1, 2, 3, 4, 5, 6, 7, 8, 9]

[1, 2, 3] |>> lists::append([4, 5, 6])
          |>> lists::append([7, 8, 9])
# => [7, 8, 9, 4, 5, 6, 1, 2, 3]
```

### Other assorted features
```ruby
### Ranges
1..10 # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# WIP
```


### Not supported features
- Class inheritance
- Lisp-like Macro definition

## Requirements
- Erlang/OTP >= 18.0
- Elixir >= 1.1

## Installation
```sh
$ git clone https://github.com/i2y/manju.git
$ cd manju
$ mix archive.build
$ mix archive.install
$ cp manju <any path>
```

## Usage
### Command
```sh
$ ls
foo.mj
$ manju foo.mj
$ ls
foo.beam foo.mj
```

### Mix
mix.exs file example:
```elixir
defmodule MyApp.Mixfile do
  use Mix.Project

  def project do
    [app: :my_app,
     version: "1.0.0",
     compilers: [:manju|Mix.compilers],
     deps: [{:manju, git: "https://github.com/i2y/manju.git"}]]
  end
end
```
".mj" files in source directory(src) is automatically compiled by Mix command.
