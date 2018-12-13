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
- What's more, owing to the Parametric polymorphism in Java, when designing inventory for players, instead of creating multiple types of inventory classes, we can have an inventory class that takes all kinds of items. By doing this, programmers can avoid large amount of similar codes, since all inventories will have exactly the same features, and will thus increase programmer efficiency. Consider the following code, note that this code snippet will use the same `Item` class from the previous code.
```Java
class Player {
  String name = "";
  Inventory<Item> mBackPack = null;
  
  public Player(String name, Inventory<Item> backpack) {
    this.name = name;
    mBackPack = backpack;
  }
}

class Inventory<E> {

}
```
