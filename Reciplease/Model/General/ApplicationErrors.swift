//
//  ApplicationErrors.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
enum ApplicationErrors: Error, CustomStringConvertible, Equatable {
    
    // MARK: - Errors
    
    // network call
    case ncNoData, ncNoResponse, ncBadCode(Int), ncDataConformityLess
    
    // MARK: - Descriptions
    
    /// Description to print in the console for developpers to know whats is the problem.
    var description: String {
        switch self {
        // network call
        case .ncNoData:
            return "La réponse ne retourne aucune data [Model/General/JSONStructureDecoder].\(codeMeaning)"
        case .ncNoResponse:
            return "La réponse retourne nil [Model/General/JSONStructureDecoder]."
        case .ncBadCode(_):
            return "La réponse retourne un code HTTP invalide \(codeMeaning) [Model/General/JSONStructureDecoder]."
        case .ncDataConformityLess:
            return "Les data ne sont pas conformes à la JSONStructure  [Model/General/JSONStructureDecoder]."
        }
    }
}

extension ApplicationErrors {
    // MARK: - Code Meaning
    /// Return the meaning of the HTTP code.
    private var codeMeaning: String {
        switch self {
        case .ncBadCode(let code):
            var text = "[code: \(code): "
            switch code {
            case 100:
                text += "Continue: Attente de la suite de la requête."
            case 101:
                text += "Switching Protocols: Acceptation du changement de protocole."
                
            case 102:
                text += "Processing: WebDAV RFC 2518: Traitement en cours (évite que le client dépasse le temps d’attente limite)."
            case 103:
                text += "Early Hints: RFC 8297 : (Expérimental) Dans l'attente de la réponse définitive, le serveur retourne des liens que le client peut commencer à télécharger."
            case 201:
                text += "Created: Requête traitée avec succès et création d’un document."
            case 202:
                text += "Accepted: Requête traitée, mais sans garantie de résultat."
            case 203:
                text += "Non-Authoritative Information: Information retournée, mais générée par une source non certifiée."
            case 204:
                text += "No Content: Requête traitée avec succès mais pas d’information à renvoyer."
            case 205:
                text += "Reset Content: Requête traitée avec succès, la page courante peut être effacée."
            case 206:
                text += "Partial Content: Une partie seulement de la ressource a été transmise."
            case 207:
                text += "Multi-Status: WebDAV : Réponse multiple."
            case 208:
                text += "Already Reported: WebDAV : Le document a été envoyé précédemment dans cette collection."
            case 210:
                text += "Content Different: WebDAV : La copie de la ressource côté client diffère de celle du serveur (contenu ou propriétés)."
            case 226:
                text += "IM Used: RFC 3229 : Le serveur a accompli la requête pour la ressource, et la réponse est une représentation du résultat d'une ou plusieurs manipulations d'instances appliquées à l'instance actuelle."
            case 300:
                text += "Multiple Choices: L’URI demandée se rapporte à plusieurs ressources."
            case 301:
                text += "Moved Permanently: Document déplacé de façon permanente."
            case 302:
                text += "Found: Document déplacé de façon temporaire."
            case 303:
                text += "See Other: La réponse à cette requête est ailleurs."
            case 304:
                text += "Not Modified: Document non modifié depuis la dernière requête."
            case 305:
                text += "Use Proxy (depuis HTTP/1.1): La requête doit être ré-adressée au proxy."
            case 306:
                text += "Switch Proxy: Code utilisé par une ancienne version de la RFC 2616, à présent réservé. Elle signifiait « Les requêtes suivantes doivent utiliser le proxy spécifié »."
            case 307:
                text += "Temporary Redirect: La requête doit être redirigée temporairement vers l’URI spécifiée."
            case 308:
                text += "Permanent Redirect: La requête doit être redirigée définitivement vers l’URI spécifiée."
            case 310:
                text += "Too many Redirects: La requête doit être redirigée de trop nombreuses fois, ou est victime d’une boucle de redirection."
            case 400:
                text += "Bad Request: La syntaxe de la requête est erronée."
            case 401:
                text += "Unauthorized: Une authentification est nécessaire pour accéder à la ressource."
            case 402:
                text += "Payment Required: Paiement requis pour accéder à la ressource."
            case 403:
                text += "Forbidden: Le serveur a compris la requête, mais refuse de l'exécuter. Contrairement à l'erreur 401, s'authentifier ne fera aucune différence. Sur les serveurs où l'authentification est requise, cela signifie généralement que l'authentification a été acceptée mais que les droits d'accès ne permettent pas au client d'accéder à la ressource."
            case 404:
                text += "Not Found: Ressource non trouvée."
            case 405:
                text += "Method Not Allowed: Méthode de requête non autorisée."
            case 406:
                text += "Not Acceptable: La ressource demandée n'est pas disponible dans un format qui respecterait les en-têtes « Accept » de la requête."
            case 407:
                text += "Proxy Authentication Required: Accès à la ressource autorisé par identification avec le proxy."
            case 408:
                text += "Request Time-out: Temps d’attente d’une requête du client, écoulé côté serveur. D'après les spécifications HTTP : « Le client n'a pas produit de requête dans le délai que le serveur était prêt à attendre. Le client PEUT répéter la demande sans modifications à tout moment ultérieur »."
            case 409:
                text += "Conflict: La requête ne peut être traitée en l’état actuel."
            case 410:
                text += "Gone: La ressource n'est plus disponible et aucune adresse de redirection n’est connue."
            case 411:
                text += "Length Required: La longueur de la requête n’a pas été précisée."
            case 412:
                text += "Precondition Failed: Préconditions envoyées par la requête non vérifiées."
            case 413:
                text += "Request Entity Too Large: Traitement abandonné dû à une requête trop importante."
            case 414:
                text += "Request-URI Too Long: URI trop longue."
            case 415:
                text += "Unsupported Media Type: Format de requête non supporté pour une méthode et une ressource données."
            case 416:
                text += "Requested range unsatisfiable: Champs d’en-tête de requête « range » incorrect."
            case 417:
                text += "Expectation failed: Comportement attendu et défini dans l’en-tête de la requête insatisfaisante."
            case 418:
                text += "I’m a teapot: « Je suis une théière » : Ce code est défini dans la RFC 2324 datée du 1er avril 1998, Hyper Text Coffee Pot Control Protocol."
            case 421:
                text += "Bad mapping / Misdirected Request: La requête a été envoyée à un serveur qui n'est pas capable de produire une réponse (par exemple, car une connexion a été réutilisée)."
            case 422:
                text += "Unprocessable entity: WebDAV : L’entité fournie avec la requête est incompréhensible ou incomplète."
            case 423:
                text += "Locked: WebDAV : L’opération ne peut avoir lieu car la ressource est verrouillée."
            case 424:
                text += "Method failure: WebDAV : Une méthode de la transaction a échoué."
            case 425:
                text += "Too Early: RFC 8470 : Le serveur ne peut traiter la demande car elle risque d'être rejouée."
            case 426:
                text += "Upgrade Required: RFC 2817 : Le client devrait changer de protocole, par exemple au profit de TLS/1.0."
            case 428:
                text += "Precondition Required: RFC 6585 : La requête doit être conditionnelle."
            case 429:
                text += "Too Many Requests: RFC 6585 : Le client a émis trop de requêtes dans un délai donné."
            case 431:
                text += "Request Header Fields Too Large: RFC 6585 : Les entêtes HTTP émises dépassent la taille maximale admise par le serveur."
            case 449:
                text += "Retry With: Code défini par Microsoft. La requête devrait être renvoyée après avoir effectué une action."
            case 450:
                text += "Blocked by Windows Parental Controls : Code défini par Microsoft. Cette erreur est produite lorsque les outils de contrôle parental de Windows sont activés et bloquent l’accès à la page."
            case 451:
                text += "Unavailable For Legal Reasons: Ce code d'erreur indique que la ressource demandée est inaccessible pour des raisons d'ordre légal."
            case 456:
                text += "Unrecoverable Error: WebDAV : Erreur irrécupérable."
            case 444:
                text += "No Response: Indique que le serveur n'a retourné aucune information vers le client et a fermé la connexion. Visible seulement dans les journaux du serveur Nginx."
            case 495:
                text += "SSL Certificate Error: Une extension de l'erreur 400 Bad Request, utilisée lorsque le client a fourni un certificat invalide."
            case 496:
                text += "SSL Certificate Required: Une extension de l'erreur 400 Bad Request, utilisée lorsqu'un certificat client requis n'est pas fourni."
            case 497:
                text += "HTTP Request Sent to HTTPS Port: Une extension de l'erreur 400 Bad Request, utilisée lorsque le client envoie une requête HTTP vers le port 443 normalement destiné aux requêtes HTTPS."
            case 498:
                text += "Token expired/invalid: Le jeton a expiré ou est invalide."
            case 499:
                text += "Client Closed Request: Le client a fermé la connexion avant de recevoir la réponse. Cette erreur se produit quand le traitement est trop long côté serveur."
            case 500:
                text += "Internal Server Error: Erreur interne du serveur."
            case 501:
                text += "Not Implemented: Fonctionnalité réclamée non supportée par le serveur."
            case 502:
                text += "Bad Gateway ou Proxy Error: En agissant en tant que serveur proxy ou passerelle, le serveur a reçu une réponse invalide depuis le serveur distant."
            case 503:
                text += "Service Unavailable: Service temporairement indisponible ou en maintenance."
            case 504:
                text += "Gateway Time-out: Temps d’attente d’une réponse d’un serveur à un serveur intermédiaire écoulé."
            case 505:
                text += "HTTP Version not supported: Version HTTP non gérée par le serveur."
            case 506:
                text += "Variant Also Negotiates: RFC 2295 : Erreur de négociation. Transparent content negociation."
            case 507:
                text += "Insufficient storage: WebDAV : Espace insuffisant pour modifier les propriétés ou construire la collection."
            case 508:
                text += "Loop detected: WebDAV : Boucle dans une mise en relation de ressources (RFC 5842)."
            case 509:
                text += "Bandwidth Limit Exceeded: Utilisé par de nombreux serveurs pour indiquer un dépassement de quota."
            case 510:
                text += "Not extended: RFC 2774 : La requête ne respecte pas la politique d'accès aux ressources HTTP étendues."
            case 511:
                text += "Network authentication required: RFC 6585 : Le client doit s'authentifier pour accéder au réseau. Utilisé par les portails captifs pour rediriger les clients vers la page d'authentification."
            case 520:
                text += "Unknown Error: L'erreur 520 est utilisé en tant que réponse générique lorsque le serveur d'origine retourne un résultat imprévu."
            case 521:
                text += "Web Server Is Down: Le serveur a refusé la connexion depuis Cloudflare."
            case 522:
                text += "Connection Timed Out: Cloudflare n'a pas pu négocier un TCP handshake avec le serveur d'origine."
            case 523:
                text += "Origin Is Unreachable: Cloudflare n'a pas réussi à joindre le serveur d'origine. Cela peut se produire en cas d'échec de résolution de nom de serveur DNS."
            case 524:
                text += "A Timeout Occurred: Cloudflare a établi une connexion TCP avec le serveur d'origine mais n'a pas reçu de réponse HTTP avant l'expiration du délai de connexion."
            case 525:
                text += "SSL Handshake Failed: Cloudflare n'a pas pu négocier un SSL/TLS handshake avec le serveur d'origine."
            case 526:
                text += "Invalid SSL Certificate: Cloudflare n'a pas pu valider le certificat SSL présenté par le serveur d'origine."
            case 527:
                text += "Railgun Error: L'erreur 527 indique que la requête a dépassé le délai de connexion ou a échoué après que la connexion WAN ait été établie."
            default:
                text += "Code inconnu."
            }
            text += "]"
            return text
        default:
            return ""
        }
    }
}




/*

 
 */
