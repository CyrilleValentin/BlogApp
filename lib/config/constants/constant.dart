//Images
const String homeImage = "assets/images/Illustration.png";
const String backImage = "assets/images/background.png";
//Routes
const String loginRoute = "/login";
const String registerRoute = "/register";
const String homeRoute = "/home";
//Texte
const String strLogin1="Connecte toi à ton compte";
const String strLogin2="Tu n'as pas de compte?";
const String strRegister1="Créez un compte, C'est gratuit";
const String strRegister2="Connecte toi à ton compte";
const String nameHint = "Veuillez saisir votre nom";
const String emailHint = "Veuillez saisir votre email";
const String emailVerifHint = "Veuillez entrer une adresse email valide";
const String passwordHint = "Veuillez saisir votre mot de passe";
const String password8CaractHint = 'Le mot de passe doit contenir au moins 8 caractères';
const String confpasswordHint = "Veuillez confirmer votre mot de passe";
const String confVerifpasswordHint = "Les mots de passe ne correspondent pas";

const baseUrl='https://blogapp.0xzales.com';
const loginUrl= '$baseUrl/login';
const registerUrl= '$baseUrl/register';
const logoutUrl= '$baseUrl/logout';
const userUrl= '$baseUrl/user';
const postsUrl= '$baseUrl/posts';
const commentsUrl= '$baseUrl/comments';

const serverError='server error';
const unauthorised='Unauthorised';
const somethingWentWrong='Something went wrong, try again!';

//Regex
final RegExp emailRegex =
    RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
final RegExp passwordRegex = RegExp(r'^.{8,}$');