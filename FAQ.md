# Frequently Asked Questions

---

Q: What's the meaning of x.y.z in your version numbers?

A: We use a [Semantic Versioning](http://semver.org/) like scheme of MAJOR.MINOR.PATCH:

The MAJOR version numbers will only change when backwards incompatible changes are made to the public interface.

The MINOR version number will change when adding new functionality or some extensive changes in code. But in any case the public interface will be fully backwards compatible.

The PATCH number will change when fixing bugs or implementing internal or minor improvements. No changes will be made to the public interface.

Additionally a `b` will be added for beta (i.e. prerelease) versions.

---

Q: Why have you `protected` methods in your classes?

A: It is the tersest way we found of defining a public interface. The non-public interface can be changed at any time, even when just releasing minor patches.

---

Q: Nevertheless, I wish I could use that protected methods.

A: You can. Just use `object.send(:desired_method)` or make the method public adding to your code the following:

    module Miniparse
      class DesiredClass
        public :desired_method
      end
    end
  
---


