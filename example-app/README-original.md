# Coffee Shop Manager with Kotlin and React
 
This example app shows how to create a Kotlin Spring Boot API and CRUD (create, read, update, and delete) its data with a React app.

Please read [Build a CRUD Application with Kotlin and React](https://developer.okta.com/blog/2020/01/13/kotlin-react-crud) to see how this app was created.

**Prerequisites:** 

* **Java 11**: This project uses Java 11. If you don't have Java 11, you can install OpenJDK. Instructions are found on the [OpenJDK website](https://openjdk.java.net/install/).
* **Node 12**: You'll need Node to create and run your React application. You can install it with Homebrew or download it from [nodejs.org](https://nodejs.org).
* **Yarn**: Yarn is a javascript package manager. You'll use it for the React UI application. To install Yarn, head to [their website for instructions](https://yarnpkg.com/lang/en/docs/install/#mac-stable).
* **Okta Developer Account**: You'll be using Okta as an OAuth/OIDC provider to add JWT authentication and authorization to the application. Go to [their website](https://developer.okta.com/signup/) and sign up for one of their free developer accounts, if you haven't already.

> [Okta](https://developer.okta.com/) has Authentication and User Management APIs that reduce development time with instant-on, scalable user infrastructure. Okta's intuitive API and expert support make it easy for developers to authenticate, manage, and secure users and roles in any application.

* [Getting Started](#getting-started)
* [Start the Apps](#start-the-apps)
* [Links](#links)
* [Help](#help)
* [License](#license)

## Getting Started

To install this example application, run the following commands:

```bash
git clone https://github.com/oktadeveloper/okta-kotlin-react-crud-example.git kotlin-react-app
cd kotlin-react-app
```

This will get a copy of the project installed locally. Before the projects apps will run, however, you need to create an OIDC application in Okta and configure the client and server to use it.

### Create an OIDC Application in Okta

You will need to create an OIDC Application in Okta to get your values to perform authentication. 

Log in to your Okta Developer account (or [sign up](https://developer.okta.com/signup/) if you don’t have an account) and navigate to **Applications** > **Add Application**. 

1. Click **Single-Page App**, click **Next**, and give the app a name you’ll remember. 
2. Specify `http://localhost:3000/callback` as a **Login Redirect URI** and `https://localhost:3000` as a **Logout redirect URI**. 
3. Specify `http://localhost:3000` as a **Base URI**. 
4. Click **Done**. 

#### Server Configuration

Set the `issuer` and copy the `clientId` into `resourceserver/src/main/resources/application.properties`. 

**NOTE:** The value of `{yourOktaUrl}` should be something like `dev-123456.com`. Make sure you don't include `-admin` in the value!

```properties
okta.oauth2.issuer=https://{yourOktaUrl}/oauth2/default
okta.oauth2.clientId={yourClientId}
```

#### Client Configuration

The React client also needs to be configured with the Okta OAuth properties. Open the `src/App.js` file and look in the `App` component, toward the bottom of the module. You need to fill in your Client ID and Issuer URL in the properties of the Security component.

```jsx
class App extends Component {

  render() {
    return (
      <Router>
        <Security issuer='https://{yourOktaUrl}/oauth2/default'
                  clientId='{yourClientId}'
                  redirectUri={window.location.origin + '/callback'}
                  pkce={true}>
          <Route path='/callback' component={LoginCallback} />
          <AuthWrapper />
        </Security>
      </Router>
    )
  }
}
```

## Start the Apps

To install all of its dependencies and start each app, follow the instructions below.

To run the server, run the following command in the `resourceserver` directory:
 
```bash
./gradlew bootRun
```

To run the client, cd into the `client` folder and run:
 
```bash
yarn && yarn start
```

## Links

This example uses the following open source libraries:

* [React](https://reactjs.org/)
* [Kotlin](https://github.com/JetBrains/kotlin)
* [Spring Boot](https://spring.io/projects/spring-boot)
* [Spring Security](https://spring.io/projects/spring-security)

It also uses these Okta libraries:

* [Okta Spring Boot Starter](https://github.com/okta/okta-spring-boot#readme)
* [Okta React SDK](https://github.com/okta/okta-oidc-js/tree/master/packages/okta-react#readme)

## Help

Please post any questions as comments on the [blog post](https://developer.okta.com/blog/2020/01/13/kotlin-react-crud), or visit our [Okta Developer Forums](https://devforum.okta.com/).

## License

Apache 2.0, see [LICENSE](LICENSE).
