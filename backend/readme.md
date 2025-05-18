## Language app
DUT's Mobile Development final project.

### Git commit convention
Use [this](./docs/git_convention.pdf) convention, (by [HighTenHunter](https://github.com/High10Hunter)) 


### Self-note
These notes are my findings while coding this project:



#### List layout and performance

In home screen list, I want to lay out the lessons in a widget list, like this:
![Duolingo home layout](home_layout.PNG)

I think I've partially found the pattern behind the spriral layout:

![alt text](unit_math.png)

About performance:
- Used `ScrollablePositionedList` to create a list view that also accept a index listener -> change the top unit menu index

- Problem: using `setState` inside `home_view.dart` to update the current index -> > 16ms reload when at different index
- Solution: use a ValueNotifier and update that notifier only

![Before](image.png)
![After](image-1.png)


- Potential further solution: Use a Flow widget and specify a Sine wave in it's delegate


