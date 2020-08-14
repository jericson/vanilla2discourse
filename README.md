# vanilla2discourse

A collection of scripts to help transfer a community from Vanilla to
Discourse. May only be useful for me.

You'll want to set three environment variables:

* `VANILLA_API`&mdash;Acquire via `https://YOUR_VANILLA_SITE/profile/tokens`.
* `DISCOURSE_API`&mdash;;Acquire via `https://YOUR_DISCOURSE_SITE/admin/api/keys`.
* `DISCOURSE_USER`

You'll also want at least one existing Vanilla site and one Discourse
site you want move to. (Now some of these scripts aren't _technically_
related to Vanilla at all and are just handy for adjusting Discourse
configuration.)

## tier_categories.rb

Vanilla allows any level of category/forum nesting. Discourse only
allows one. That is to say, each Discourse category my have up to one
parent and no category with children may have a parent. It's a
dystopian (or utopian, depending on your point of view)
grandparent-less existence. It's also a lot simpler.

The idea behind this script is to pick one level to be the top level
and stuff all categories anywhere beneath that level to be direct
children. So if in Vanilla you have:

* Top level!
  * Next level
    * Under leveled
      * Sublevel
    
Then in Discourse, you could set the main depth to be 2 and get:

* Top level!
* Next level
  * Under leveled
  * Sublevel

```
$ ./tier_categories.rb talk.collegeconfidential.com discuss.qa.collegeconfidential.com -t 2
```


## flatten_cats.rb

This does the reverse of `tier_categories.rb`. It goes through all the
Discourse categories that have parents and makes them top-level. This
might be necessary if you, I don't know, screw up the previous
script. (Not that I would know. 8-)

```
./flatten_cats.rb discuss.qa.collegeconfidential.com
```

## 

<!--  LocalWords:  utopian
 -->
