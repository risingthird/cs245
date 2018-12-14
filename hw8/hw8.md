# Assignment	8:	The	Case	for	a	Programming	Language

## Background
### Company 
`Mintendo`, a start-up mobile-app company aims at offline games.
### Project
An achievement system in the game called `Bright Souls`. Specifically, each achievement will be fulfilled as soon as players finish collecting required items, including armors, weapons, killed monsters, etc. Note that sub-achievements have the potential forming a larger achievement. Additionally, this system should have the ability of adding more achievements as the game itself updates. There's also a need to build corresponding player system and inventory system.
### Our team
Brad, an expert in Scala, has been in the game industry for more than 8 years.

Suresh, an expert in Java, has been written code for a health-care company for over 15 years.

Giaping, a new grad from Haverford College, has just published a mobile game on Google Store, which has more than 100,000 downloads.

Miyamoto is our product manager, and is the one we want to convice.

## Argument
In order to implement system, it's better for us to use Java instead of Python.

- First of all, as an object-oriented language, Java has polymorphism that is suitable for this scenario. Specifically speaking, the requirements of achievements have a clear hireachy based on the nature of the system itself. For instance, armors and weapons are subtypes of Items, each specific kind of monsters is a subtype of Monster. Let requirement be a class. Suppose for each requirement instance, there will be a HashMap storing specific requirements, that maps items to their required amount. Using polymorphism in Java, instead of having maps for each kind of item, we can have a general map that takes in multiple subtypes of item class as key. 
```Java
class Item {
  private String item_name;
  private int val;
  
  public Item() { 
    item_name = "default item";
    val = 0;
  }
  
  public Item(String name, int val) {
    this.item_name = name;
    this.val = val;
  }
}

class Armor extends Item {
  private int defense;
  
  public Armor() {
    super();
    defense = 0;
  }
  
   public Armor(String name, int val, int defense) {
    super(name, val);
    defense = defense;
  }
}

class Sword extends Item {
  private int attack;
  
  public Sword() {
    super();
    attack = 0;
  }
  
   public Sword(String name, int val, int attack) {
    super(name, val);
    defense = attack;
  }
}

class Requirement {
  HashMap<Item, Integer> mMap = null;
  public Requirement() {
    mMap = new HashMap<Item, Integer>();
  }
  
  public void addNewRequirement(Item item, int amount) {
    if (mMap.containsKey(item)) {
      mMap.put(item, mMap.get(item) + amount);
    }
    else {
      mMap.put(item, amount);
    }
  }
   
}

```
- When designing inventory system, it is necessary to separate mission related items from general items, which results in two types of inventories. However, this will cause redundancy in code since both inventories will have similar functions. Under such a circumstance, we can take the advantage `parametric polymorphism` in Java. Owing to `parametric polymorphism`, when designing inventory for players, instead of creating multiple types of inventory classes, we can have an inventory class that takes all kinds of items. By doing this, programmers can avoid redundancy, and will thus increase programmer efficiency. Consider the following code, note that this code snippet will use the same `Item` class from the previous code.
```Java
class Player {
  String name = "";
  Inventory<Item> mBackPack = null;
  Inventory<MissionItem> mMissionPack = null;
  
  public Player(String name, Inventory<Item> backpack, Inventory<MissionItem> missionpack) {
    this.name = name;
    mBackPack = backpack;
    mMissionPack = missionpack;
  }
}

class Inventory<E> {
  HashMap<E, Integer> pack = null;
  public Inventory() {
    pack = new HashMap<E, Integer>();
  }
  
  public void addItem(E item, int amount) {
    if (pack.containsKey(item)) {
      pack.put(item, mMap.get(item) + amount);
    }
    else {
      pack.put(item, amount);
    }  
  }
  
  public void deleteItem(E item, int amount) {
    if (pack.containsKey(item)) {
      pack.put(item, mMap.get(item) - amount);
    }
    else {
      System.out.println("Item does not exist");
    }  
  }
}
```
- As our system gets bigger, it might be possible that we accidentally add something other than Items to users' backpacks or add strange requirements. However, since Java is a statically typed language, this kind of error will be eliminated during compile time, and thus won't cause potential crash in our app. Consider the following code:
```Java
public static void main(String[] args) {
  Inventory<Item> backpack = new Inventory<>();
  // this will cause a compile time error, since we try to put a String rather than an item into the bag
  backpack.addItem("Cat", 1);
  backpack.addItem(new Sword("Cat", 10000, 1), 1); // this line is ok, since Sword object is a subtype of Item
}
```
Now we want to take python as a counterexample. The following code shows the potential risks of dynamic type language:
```Python
backpack = Inventory() # Inventory class is just a list
backpack.addItem(Sword("Cat", 10000, 1), 1) # this is valid
backpack.addItem("Cat", 1)  # This is also valid, since a python list can takes all kinds of inputs. 
                            # However, when we try to iterate through the list and get the item, 
                            # it will return a String rather than an item
```
