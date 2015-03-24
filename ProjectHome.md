<img src='http://www.aboundlessworld.com/wp-content/uploads/2009/02/abc_blocks.jpg' width='500'>

An AS3 MVC (Model/View/Controller) with different complexity.<br>
<br>
A: Anaconda / ant  : as simple as it gets<br>
B: Baracuda / bee  : somewhat bigger <br>
C: Chupacabra / .. : Biggest version<br>

D: Dragon / ..     : my working version of ABC-MVC<br>
<br>
Keep in mind this project is mainly for projects with just "Pure Actionscript" at heart, this project would need some modifications to work within the "Adobe Flex Framework." It's setup more for a project with the IDE and .fla files.<br>
<br>
For the most part this project implements the Model, View, Controller - a Design Pattern that is scalable for most projects using an OOP process. It's a basic MVC structure with a method to apply, with assistance from the Preloader and Application classes. It's also very handy for productive workflow; as a good practice you can setup your model logic and application logic first once your data is ready. Then it's just a matter of displaying and controlling the representation of that model. So if needed, more than one developer can work on an application. Each developer can work on different views or components or states of the overall view. Without depending on controllers or other views, each view just has to listen for what it wants to from the model.<br>
<br>
Preloader<br>
<br>
The Preloader for the Application class best practice is to extend this class for your own preloader class and then add the frame command to your own application class which is extended from org.simplemvc.core.Application. Look at the example flash application directory for further explanation.<br>
<br>
Application<br>
<br>
This is the specific class that starts an application. It adds all the necessary views and sets the model up. This is where you will pass to the model what data to use and you will also pass the model to all the views in their own constructors.<br>
<br>
Model<br>
<br>
The Model component of the MVC design pattern handles and stores the data and application logic for the interface. It is recommended that the Model utilize a push only dispatching protocol in which it dispatches information to it's listeners through the event object. This happens without any knowledge of who or what is listening. It is recommended that this class is sub classed in order to communicate and manage application logic, however you can use it directly as well.<br>
<br>
View<br>
<br>
The View component of the MVC design pattern is a distinct representation of a Model's data and or logic. A view listens too and represents changes to the model for states of the application or logic. It is recommended that the views in an MVC system be unaware of the inner workings of the system's Model (ie. utilize a push only dispatching protocol in which the Model pushes information to it's listeners through the event object). It is the responsibility of each view to make sure it has a controller. The controller can either be passed in to the constructor or it will be automatically made by the view's. To create an MVC relationship; a model is created and a view is created which is then added as a listener of its associated model. The view primarily creates its own controller, but can use an existing one, this is not recommended. It will be necessary to extend this View class and the core controller method in order to make more specific view objects for specific view/controller pairings.<br>
<br>
Controller<br>
<br>
The Controller component of the MVC design pattern responds to user inputs by modifying the Model. A controller listens too its view for user inputs. If the data submitted by the view, affect the data and logic, it will report that information up to the model. Otherwise it should act directly back upon it's view ( i.e. onRollOver ). A Controller has a direct relationship with its view and the model the View represents. A Controller is generally only created by a View that will accept user input, and in some cases the View won't have the need for a Controller. If a view does not accept user input, and the default controller method is called, a null controller will be returned.