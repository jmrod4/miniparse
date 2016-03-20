
# Frequently Asked Questions

---

### What's the meaning of _x.y.z_ in your version numbers?

We use a [Semantic Versioning](http://semver.org/) like scheme of MAJOR.MINOR.PATCH:

The MAJOR version numbers will only change when backwards incompatible changes are made to the public interface.

The MINOR version number will change when adding new functionality or some extensive changes in code. But in any case the public interface will be fully backwards compatible.

The PATCH number will change when fixing bugs or implementing internal or minor improvements. No changes will be made to the public interface.

Additionally a `b` will be added for beta or a `pre` for pre-release versions.

---

### What do you mean with _public interface_?

At the moment the complete public interface is restricted to the class Parser, the control Miniparse class methods and the optional module App

You can find the complete specification in the public methods and constants on these files:

  * [miniparse.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/constants.rb)
 
  * [miniparse/parser.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/parser.rb)

  * [miniparse/control.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/control.rb)

  * [miniparse/app.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/app.rb)	
	
---

### Why have you `protected` methods in your classes?

It is the tersest way we found of defining a public interface. Please note that the non-public interface can be changed at any time, even when just releasing minor patches.

---

### Nevertheless, I wish I could use that protected methods.

You can. Just use `object.send(:desired_method)` or make the method public adding to your code the following:

    module Miniparse
      class DesiredClass
        public :desired_method
      end
    end
  
---


