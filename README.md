# vanilla2discourse

A collection of scripts to help transfer a community from Vanilla to
Discourse. May only be useful for me.

You'll want to set three environment variables:

* `VANILLA_API`&mdash;Acquire via `https://YOUR_VANILLA_SITE/profile/tokens`.
* `DISCOURSE_API`&mdash;Acquire via `https://YOUR_DISCOURSE_SITE/admin/api/keys`.
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
$ tier_categories.rb VANILLA_HOST DISCOURSE_HOST -t 2
```


## flatten_cats.rb

This does the reverse of `tier_categories.rb`. It goes through all the
Discourse categories that have parents and makes them top-level. This
might be necessary if you, I don't know, screw up the previous
script. (Not that I would know. 8-)

```
$ flatten_cats.rb DISCOURSE_HOST
```

## alpha_cats.rb

I have a big list of schools that I need to organize. The logical
first step is to use the alphabet, which is already a known sorting
method. For the purposes of this script, I remove "University of "
while sorting. This could be made general, but I'm gonna be lazy for
now. (If this seems like a useful script for your Discourse instance,
please let me know and I'll parameterize this script.)

```
$ alpha_cats.rb DISCOURSE_HOST
```

## delete_cats.rb

The solution our forums had for the large number of schools is to
alphabetize under categories named A through W and X-Y-Z. Those aren't
real categories with discussions, but just organizing
pseudo-categories. So I want to delete them. (Fun fact: the script was
originally called `kill_cats.rb`, but that started to make
`flatten_cats.rb` feel uncomfortable.)

```
$ delete_cats.rb DISCOURSE_HOST
```

## transfer_avatars.rb

People online love their avatars. How you chose to
represent yourself matters a great deal. Our import didn't bring over
avatars from Vanilla, so I wrote this post-processing script. It
ignores default avatars.

```
$ transfer_avatars.rb VANILLA_HOST DISCOURSE_HOST 
```


## update_users.rb

This script transfers avatars and also a few other things. It makes
moderators on Vanilla also moderators on Discourse. It also maps
people to the appropriate trust level based on rank:

Rank          | Trust Level
----          | -----------
New Member    |           0
Junior Member |           1
Member        |           2
Senior Member |           3

```
$ update_users.rb VANILLA_HOST DISCOURSE_HOST [-r ROLE_ID] [-u USER_COUNT]
```

<!--  LocalWords:  utopian
 -->
