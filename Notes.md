#Job Dependency Problem

1)Base case: No job > Return empty string.

2)Split string on the basis of "\n".

Example:
job_structure = "a =>
 b => c
 c => f
 d => a
 e => b
 f =>"

```ruby
job_structure.split("\n")
```

["a =>", " b => c", " c => f", " d => a", " e => b", " f =>"]

3)Now we need to loop on this array and separate jobs by using split("=>")
```ruby
job_structure.split("=>")
```
There can be two cases:
```ruby
job = ["a "]
```
```ruby
job =  [" b ", " c"]
```
4) Prepare a hash with Key as JobName and value as Job Object.

5)If the job is independent
Add jobname to result string
Else
resolve its dependence tree till there is no dependent job of a job.

e
 \
  b
   \
    c
     \
      f
