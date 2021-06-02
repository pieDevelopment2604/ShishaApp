import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shish/license.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static openEmail({String toEmail, String subject, String body}) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    await launchUrl(url);
  }

  static showLicenseDialog(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    showDialog(
        context: context,
        builder: (_) => Dialog(
              backgroundColor: Colors.white,
              child: Container(
                height: 200,
                width: 190,
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/shisha.png'))),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${appName}',
                                  style: TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                                Text('${version}'),
                                SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    'veuillez cliquer sur voir les licences\npour plus d\'informations.',
                                    maxLines: 3,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     TextButton(
                                //         onPressed: () {},
                                //         child: Text('LICENSE')),
                                //     TextButton(
                                //       onPressed: () {},
                                //       child: Text('CLOSE'),
                                //     )
                                //   ],
                                // )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Align(alignment: Alignment.bottomRight,
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>License()));
                                // Navigator.pop(context, true);
                              },
                              child: Text('voir les licences')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('fermer'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));

    // showAboutDialog(
    //   context: context,
    //   applicationVersion: version,
    //   applicationIcon: Center(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 8.0),
    //       child: SizedBox(
    //         width: 32,
    //         height: 32,
    //         child: Image.asset('assets/shisha.png'),
    //       ),
    //     ),
    //   ),
    //   applicationLegalese:
    //       'veuillez cliquer sur voir les licences pour plus d\'informations.',
    //
    //   /*children: [
    //     Padding(
    //       padding: const EdgeInsets.only(top: 20),
    //       child: Text('This is where I\'d put more information about '
    //           'this app, if there was anything interesting to say.'),
    //     ),
    //   ],*/
    // );
  }

  static String licenceText = "Politique de cookies" +
      "\n\nLiens hypertextes « cookies » et balises (“tags”) internet" +
      "\nLe site https://shish.fr  contient un certain nombre de liens hypertextes vers d’autres sites, mis en place avec l’autorisation de https://shish.fr   Cependant, https://shish.fr  . n’a pas la possibilité de vérifier le contenu des sites ainsi visités, et n’assumera en conséquence aucune responsabilité de ce fait." +
      "\n\nSauf si vous décidez de désactiver les cookies, vous acceptez que le site puisse les utiliser. Vous pouvez à tout moment désactiver ces cookies et ce gratuitement à partir des possibilités de désactivation qui vous sont offertes et rappelées ci-après, sachant que cela peut réduire ou empêcher l’accessibilité à tout ou partie des Services proposés par le site.\n\n" +
      "\n\n« COOKIES »" +
      "\n\nUn « cookie » est un petit fichier d’information envoyé sur le navigateur de l’Utilisateur et enregistré au sein du terminal de l’Utilisateur (ex : ordinateur, smartphone), (ci-après « Cookies »). Ce fichier comprend des informations telles que le nom de domaine de l’Utilisateur, le fournisseur d’accès Internet de l’Utilisateur, le système d’exploitation de l’Utilisateur, ainsi que la date et l’heure d’accès. Les Cookies ne risquent en aucun cas d’endommager le terminal de l’Utilisateur." +
      "\n\nhttps://shish.fr   est susceptible de traiter les informations de l’Utilisateur concernant sa visite du Site, telles que les pages consultées, les recherches effectuées. Ces informations permettent à https// shish.fr  . d’améliorer le contenu du Site, de la navigation de l’Utilisateur." +
      "\n\nLes Cookies facilitant la navigation et/ou la fourniture des services proposés par le Site, l’Utilisateur peut configurer son navigateur pour qu’il lui permette de décider s’il souhaite ou non les accepter de manière à ce que des Cookies soient enregistrés dans le terminal ou, au contraire, qu’ils soient rejetés, soit systématiquement, soit selon leur émetteur. L’Utilisateur peut également configurer son logiciel de navigation de manière à ce que l’acceptation ou le refus des Cookies lui soient proposés ponctuellement, avant qu’un Cookie soit susceptible d’être enregistré dans son terminal. https// shish.fr  . informe l’Utilisateur que, dans ce cas, il se peut que les fonctionnalités de son logiciel de navigation ne soient pas toutes disponibles." +
      "\n\nSi l’Utilisateur refuse l’enregistrement de Cookies dans son terminal ou son navigateur, ou si l’Utilisateur supprime ceux qui y sont enregistrés, l’Utilisateur est informé que sa navigation et son expérience sur le Site peuvent être limitées. Cela pourrait également être le cas lorsque https// shish.fr  . ou l’un de ses prestataires ne peut pas reconnaître, à des fins de compatibilité technique, le type de navigateur utilisé par le terminal, les paramètres de langue et d’affichage ou le pays depuis lequel le terminal semble connecté à Internet." +
      "\n\nLe cas échéant, https//shish.fr  . décline toute responsabilité pour les conséquences liées au fonctionnement dégradé du Site et des services éventuellement proposés par https// shish.fr   résultant (i) du refus de Cookies par l’Utilisateur (ii) de l’impossibilité pour https// shish.fr   d’enregistrer ou de consulter les Cookies nécessaires à leur fonctionnement du fait du choix de l’Utilisateur. Pour la gestion des Cookies et des choix de l’Utilisateur, la configuration de chaque navigateur est différente. Elle est décrite dans le menu d’aide du navigateur, qui permettra de savoir de quelle manière l’Utilisateur peut modifier ses souhaits en matière de Cookies." +
      "\n\nÀ tout moment, l’Utilisateur peut faire le choix d’exprimer et de modifier ses souhaits en matière de Cookies. https// shish.fr   pourra en outre faire appel aux services de prestataires externes pour l’aider à recueillir et traiter les informations décrites dans cette section." +
      "\n\nEnfin, en cliquant sur les icônes dédiées aux réseaux sociaux figurant sur le Site de https// shish.fr   ou dans son application mobile et si l’Utilisateur a accepté le dépôt de cookies en poursuivant sa navigation sur le Site Internet ou l’application mobile de https// shish.fr  peuvent également déposer des cookies sur vos terminaux (ordinateur, tablette, téléphone portable)." +
      "\n\nCes types de cookies ne sont déposés sur vos terminaux qu’à condition que vous y consentiez, en continuant votre navigation sur le Site Internet ou l’application mobile de https// shish.fr  . À tout moment, l’Utilisateur peut néanmoins revenir sur son consentement à ce que https// shish.fr   dépose ce type de cookies." +
      "\n\n\nBALISES (“TAGS”) INTERNET" +
      "\n\nhttps// shish.fr   peut employer occasionnellement des balises Internet (également appelées « tags », ou balises d’action, GIF à un pixel, GIF transparents, GIF invisibles et GIF un à un) et les déployer par l’intermédiaire d’un partenaire spécialiste d’analyses Web susceptible de se trouver (et donc de stocker les informations correspondantes, y compris l’adresse IP de l’Utilisateur) dans un pays étranger." +
      "\n\nCes balises sont placées à la fois dans les publicités en ligne permettant aux internautes d’accéder au Site, et sur les différentes pages de celui-ci." +
      "\n\nCette technologie permet à https// shish.fr   d’évaluer les réponses des visiteurs face au Site et l’efficacité de ses actions (par exemple, le nombre de fois où une page est ouverte et les informations consultées), ainsi que l’utilisation de ce Site par l’Utilisateur." +
      "\n\nLe prestataire externe pourra éventuellement recueillir des informations sur les visiteurs du Site et d’autres sites Internet grâce à ces balises, constituer des rapports sur l’activité du Site à l’attention de https// shish.fr  , et fournir d’autres services relatifs à l’utilisation de celui-ci et d’Internet." +
      "\n\n" +
      "\n\nConditions générales de ventes\n" +
      "\n" +
      "Article 1: Préambule\n" +
      " \n" +
      "Les présentes conditions générales de vente s'appliquent entre l'entreprise SHISH et toute personne visitant ou effectuant un achat via le site  www.shish.fr OU l’application shish.\n" +
      " \n" +
      "L'entreprise SHISH se réserve la possibilité d'adapter ou de modifier à tout moment les présentes conditions générales de vente. En cas de modification,  les conditions générales de vente en vigueur au jour de la commande seront appliquées.\n" +
      " \n" +
      "Toute prise de commande au titre d'un produit figurant au sein de la boutique en ligne du site www.shish.fr  suppose la consultation préalable des présentes conditions générales. Les informations contractuelles sont présentées en langue française.\n" +
      " \n" +
      "Article 2: Produits\n" +
      " \n" +
      "L'entreprise shish présente, sur son site, pour tous les produits disponibles, une description détaillée permettant à l'acheteur de connaître avant la prise de commande définitive les caractéristiques essentielles des produits qu'il souhaite acheter.\n" +
      " \n" +
      "L'acheteur dispose à tout moment de la faculté d'envoyer un courriel à l'entreprise shish s'il jugeait nécessaire d'obtenir des précisions. Les photos et illustrations sont données à titre indicatif et n'ont pas de caractère contractuel.\n" +
      " \n" +
      "Article 3: Prix\n" +
      " \n" +
      "Tous les prix présentés sont exprimés et gérés en Euro et tiennent compte de la TVA française applicable au jour de la transaction. Les frais de ports sont fixés par rapport à la distanbce entre client et partenaires pour la France Métropolitaine \n" +
      " \n" +
      "Pour les autres destinations, ces frais de ports sont calculés en fonction du poids du colis, ainsi que du pays de destination. L'entreprise shish  se réserve le droit de modifier ses prix à tout moment et sans préavis. Le prix de vente retenu pour l'achat d'un produit est celui observé en ligne au moment de l'enregistrement de la commande sur le site Internet.\n" +
      " \n" +
      "Article 4: Disponibilité\n" +
      " \n" +
      "Nos offres de produits et prix sont valables tant qu'elles sont visibles sur le site, dans la limite des stocks disponibles. A réception de votre commande, nous vérifions la disponibilité du (ou des) produit(s) commandé(s).\n" +
      " \n" +
      "En cas d'indisponibilité, nous nous engageons dans les 30 jours à compter de la validation de la commande soit à vous livrer le produit commandé, soit à vous proposer un produit similaire à un prix similaire, soit à vous le rembourser. Les délais de livraison sont donnés à titre indicatif et nous nous efforcerons de les respecter au maximum. \n" +
      " \n" +
      "Article 5: Modalités de règlement\n" +
      " \n" +
      "Le règlement des commandes s'effectue par cartes bancaires  (Carte bleue / e-carte bleue / Visa / Mastercard / American Express ) ou via un compte Paypal.\n" +
      " \n" +
      "Ceci implique qu'aucune information bancaire vous concernant ne transite via le site de l'entreprise shish Le paiement par carte bancaire est donc parfaitement sécurisé. Votre commande sera ainsi enregistrée et validée dès l'acceptation du paiement par l'établissement bancaire.\n" +
      " \n" +
      "L'entreprise shish  se réserve le droit de refuser d'effectuer une livraison ou d'honorer une commande émanant d'un consommateur qui n'aurait pas réglé totalement ou partiellement une commande précédente ou avec lequel un litige de paiement serait en cours d'administration. \n" +
      " \n" +
      "\n" +
      "Article 6: Livraison\n" +
      " \n" +
      "La livraison se fait à l'adresse spécifiée par le client lors du passage de sa commande. Elle sera effectuée par le transporteur de son choix.\n" +
      " \n" +
      "Elle ne pourra intervenir qu'une fois la commande validée par le client et le paiement effectué dans son intégralité. Les centres de paiement bancaire concernés auront donc donné au préalable leur accord de paiement. En cas de refus de paiement, la commande sera automatiquement annulée.\n" +
      " \n" +
      "Par ailleurs, l'entreprise shish  se réserve le droit de refuser toute commande d'un client avec lequel un litige en cours existerait, ou aurait préalablement existé. Les frais de livraison sont à la charge de l'acheteur, sauf promotion ou offre spéciale, et sont affichés dans le panier.\n" +
      " \n" +
      "Si l'article commandé est disponible en stock, le délai d'expédition est d'environ 24h sur jours ouvrés pour toute commande passée avant 18h, et 48h sur jours ouvrés passé cet horaire. Les délais de livraison ne débuteront qu'à partir de la date de paiement effectif de la commande.\n" +
      " \n" +
      "En cas de force majeure ou d'événements exceptionnels (catastrophe naturelle, épidémie, grèves, etc.) retardant ou interdisant la livraison des marchandises, shish  est dégagée de toute responsabilité.\n" +
      " \n" +
      "Dans tous les cas, la livraison ne peut intervenir que si le client est à jour de ses obligations envers l'entreprise shish. En signant le bordereau de livraison, le client accepte les produits livrés en l'état et dès lors aucune réclamation relative à des dommages subits durant le transport ne sera acceptée.\n" +
      " \n" +
      "Il est de la responsabilité du client d'effectuer toutes vérifications et de faire toutes réserves à l'arrivée du matériel et d'exercer, le cas échéant, tous recours contre le transporteur. Si au moment de la livraison, l'emballage d'origine est abîmé, déchiré, ouvert, vous devez alors vérifier l'état des articles.\n" +
      " \n" +
      "S'ils ont été endommagés, vous devez impérativement refuser le colis et noter une réserve sur le bordereau de livraison (colis refusé car ouvert ou endommagé).A la réception des marchandises, le client doit immédiatement vérifier leur état et leur conformité par rapport au contrat.\n" +
      " \n" +
      "Toutes les réclamations relatives à un défaut des marchandises livrées, à une inexactitude dans les quantités ou à une référence erronée par rapport à la commande, doivent être formulées par écrit sous forme de lettre recommandée avec accusé de réception dans un délai de quatre (4) jours calendaires à réception des marchandises à défaut de quoi le droit à la réclamation cessera d'être acquis. Tout retour de marchandises nécessite l'accord préalable de l'entreprise shish \n" +
      " \n" +
      "Au cas où un client ne récupèrerait pas son colis, mis à disposition par le transporteur, dans les délais d'instance impartis, l'entreprise shish  se réserve le droit de facturer des frais de traitement pour remise en stock d'un montant forfaitaire de 30euros TTC. Au cas où le client souhaiterait la ré-expédition de son colis, l'entreprise shish s'engage à renoncer à ces frais de traitement, les frais de transport de la re-livraison restant toutefois à la charge du client. Le client dispose d'un délai de 3 mois pour faire valoir ses intentions, délai à l'issu duquel le colis sera réputé appartenir à l'entreprise shish  sans que le client ne puisse prétendre à un quelconque remboursement ou dédommagement. \n" +
      " \n" +
      "Au cas où la livraison se révèlerait impossible du fait d'une adresse erronée, incomplète, ou de toute autre erreur d'adressage du fait du client, l'entreprise shish se réserve le droit de facturer des frais de traitement pour remise en stock d'un montant forfaitaire de 30  euros TTC. Le client dispose d'un délai de 3 mois pour faire valoir ses intentions, délai à l'issu duquel le colis sera réputé appartenir à l'entreprise shish sans que le client ne puisse prétendre à un quelconque remboursement ou dédommagement. \n" +
      " \n" +
      "Article n°7: Droit de rétractation\n" +
      " \n" +
      "A compter de la date de livraison de la commande, si vous êtes un particulier, vous disposez d'un délai de 15 jours pour exercer votre droit de rétractation, et être remboursé à l'exception des frais de port et de renvoi des marchandises restant à votre charge.\n" +
      " \n" +
      "Toutefois les produits incomplets, utilisés, usés, endommagés, non retournés dans l'emballage d'origine intact, ne sont pas repris. Conformément à l'ordonnance n°2001-741 du 23 août 2001, ce délai de rétractation n'est pas applicable aux produits soldés ou déstockés.\n" +
      " \n" +
      "Les produits retournés dans le cadre du droit de rétractation doivent être adressé à:\n" +
      "Leurs dépôt (bar à chicha,magasin) \n" +
      "Dans le cas où les produits ne seraient pas retournés à cette adresse, l'entreprise shish se réserve le droit de facturer le dédomagement.\n" +
      " \n" +
      "Article n°8: Garantie\n" +
      "Conformément à l'Article 4 du décret n°78-464 du 24 mars 1978, les dispositions des présentes ne peuvent priver le consommateur de la garantie légale qui oblige le vendeur professionnel à le garantir contre toutes les conséquences des vices cachés de la chose vendue.\n" +
      " \n" +
      "Le consommateur est expressément informé que l'entreprise shish n'est pas le producteur des produits présentés dans le cadre du site web, au sens de la loi n°98-389 du 19 mai 1998 et relative à la responsabilité du fait des produits défectueux.\n" +
      " \n" +
      "En conséquence, en cas de dommages causés à une personne ou à un bien par un défaut du produit, seule la responsabilité du producteur de celui-ci pourra être recherchée par le consommateur.\n" +
      " \n" +
      "Article n°9: Procédure de retour\n" +
      " \n" +
      "Toutes les demandes de retour (rétractation, non-conformité, garantie ou SAV) doivent faire l'objet d'une demande préalable auprès de notre Service Client, soit par téléphone soit par email, soit par courrier.\n" +
      " \n" +
      "A défaut d'accord, toute marchandise retournée sera tenue à la disposition du client à ses frais, risques et périls, tous frais de transport, de stockage, de manutention étant à la charge du client. Dans tous les cas, le retour des marchandises s'effectue aux frais, risques et périls du client. \n" +
      " \n" +
      "\n" +
      "\n" +
      "Article n°10: Informations\n" +
      " \n" +
      "Toutes les informations transmises à l'entreprise shish resteront strictement confidentielles et ne seront jamais vendues ou communiquées à des tiers (sauf accord du client) autres que ceux qui interviennent directement dans l'exécution de la commande.\n" +
      " \n" +
      "Conformément à la Loi Informatique et Libertés du 6 janvier 1978 et aux recommandations de la Commission Nationale Informatique et Libertés (CNIL), tout utilisateur est en droit d'accéder aux données le concernant et en réclamer la modification ou suppression.\n" +
      " \n" +
      "Toutes les demandes devront être effectuées par courrier à l'ordre de L'entrepriseSHISH, France, en nous indiquant vos nom, prénom, email, adresse, et si possible votre référence client. Les informations et données vous concernant sont nécessaires à la gestion de votre commande et à nos relations commerciales\n" +
      " \n" +
      "Article n°11: Responsabilités\n" +
      " \n" +
      "Les produits proposés sont conformes à la législation française en vigueur. Il appartient à l'acheteur de vérifier la législation du pays où les produits sont livrés.\n" +
      " \n" +
      "L'entreprise SHSIH ne pourra être tenue responsable des dommages de toute nature tant matériels, qu'immatériels ou corporels, qui pourraient résulter d'un dysfonctionnement ou d'une mauvaise utilisation des produits commandés.\n" +
      " \n" +
      "Enfin, l'entreprise SHISH ne saurait être tenue pour responsable de l'inexécution du contrat conclu à l'occasion de force majeure, de perturbation ou de grève totale ou partielle, notamment des services postaux et moyens de transport et/ou communications, d'inondation, d'incendie.\n" +
      " \n" +
      "En ce qui concerne les produits achetés pour satisfaire les besoins professionnels, L'entreprise SHISH  n'encourra aucune responsabilité pour tous dommages indirects du fait des présentes, perte d'exploitation, perte de profit, dommages ou frais, qui pourraient survenir.\n" +
      " \n" +
      "Article n°12: Réserve de propriété\n" +
      " \n" +
      "L'entreprise SHSIH en tant que vendeur, conserve la pleine propriété des biens vendus jusqu'à paiement effectif de l'intégralité du prix des biens et services concernés par la transaction.\n" +
      " \n" +
      "Article n°13: Attribution de juridiction\n" +
      " \n" +
      "Les présentes conditions générales de vente sont soumises au droit français. En cas de litige, le client et le vendeur ont la possibilité, avant toute action en justice, de rechercher une solution à l'amiable. A défaut d'une solution amiable, le Tribunal de Commerce de EVRY  est seul compétent, quels que soient le lieu de livraison et le mode de paiement utilisé. \n" +
      " \n" +
      "Article n°14: Information légale\n" +
      " \n" +
      "Nom commercial: SHISH \n" +
      "\nL'entreprise SAS au capital de 100 Euros \n" +
      "\nSiège Social:  France\n" +
      "\n" +
      "\n\nConditions Générales d’Utilisation du Site www.shish.fr \n" +
      "\nREMARQUE TRES IMPORTANTE\n" +
      "\n" +
      "L’actuelle page présente les conditions générales d’utilisation (ci-après les « CGU ») applicables à tout utilisateur (ci-après l’ « Utilisateur » ou « Vous ») à notre site internet www.shish.fr ou à notre shish  ou tout autre support ou media présent ou à venir donnant accès au site internet (ci-après ensemble le « Site internet ») édité par la société ELDEV \n" +
      "\n" +
      "L’utilisation du Site internet est soumise à l'acceptation des présentes CGU qui régissent nos relations et ce à l’exclusion de toute autre conditions générales dont vous seriez l’auteur.\n" +
      "Les présentes CGU peuvent être modifiées ou complétées à tout moment. Il convient donc de les consulter à chaque nouvelle utilisation du Site internet. En cas d’évolution substantielle des CGU portant sur les droits et obligations des parties, celle-ci devra être validée par Vous lors de votre prochaine connexion. En tout état de cause, il est précisé à toute fins utiles qu’aucune modification n’affectera une commande en cours sans votre consentement.\n" +
      "\n" +
      "La « Politique de confidentialité » et la « Politique d'Utilisation des Cookies » régissent toutes les utilisations de vos informations personnelles. \n" +
      "\n" +
      "   1. INTRODUCTION - NOTRE ROLE\n" +
      "\n" +
      "SHSIH  s’engage à effectuer, au nom et pour le compte des professionnels exploitant les entreprises partenaires référencés, sur le Site internet la commercialisation des produits à livrer (les « Produits ») auprès des Utilisateurs souhaitant passer commande.\n" +
      "\n" +
      "Merci de vous référer aux Conditions Générales de Prestation de Service (ou « CGPS ») avant la passation de commande.\n" +
      "\n" +
      "   2. ACCES AU SITE INTERNET\n" +
      "\n" +
      "2.1 Accès : La plupart des pages de notre Site internet sont libres et n’imposent pas de passer commande.\n" +
      "\n" +
      "2.2 Les présentes CGU doivent être acceptées par tout utilisateur du site avant toute action, ceci s’applique à l’exclusion de tout autre document contractuel émanant de Vous. En cas de refus de ces CGU, Vous ne pouvez pas consulter ni utiliser le Site internet.\n" +
      "\n" +
      "2.3 Les présentes CGU sont susceptibles d’être mises à jour à tout moment afin d’intégrer les modifications de la législation ou des bonnes pratiques ou pour traiter des fonctionnalités supplémentaires que nous avons implémentées. Vous serez informés avant l'entrée en vigueur de toute nouvelle version des présentes CGU. Une copie des nouvelles CGU sera mise en ligne sur le Site internet. Vous êtes invitez donc à régulièrement consulter le Site internet pour vérifier si des mises à jour ont été apportées aux présentes CGU, car après leur entrée en vigueur, vous serez tenu de les respecter lors de votre prochaine utilisation du Site internet. En cas de non acceptation de votre part de la nouvelle version des CGU du site, vous devez cesser d'utiliser le Site internet. La version des CGU applicable est celle en vigueur au jour de votre consultation du Site internet. En cas d’évolution substantielle des CGU, celle-ci devra être validée par Vous lors de votre prochaine connexion.\n" +
      "\n" +
      "2.4 Responsabilité : Vous êtes seul tenu d’assurer l’ensemble des moyens techniques vous donnant accès au Site internet. Vous êtes également responsable de toute personne qui se connecterait de votre fait ou du fait de votre négligence en utilisant votre connexion internet (notamment s’il s’agit d’un mineur) qui sera réputé connaître les présentes CGU et devra les respecter.\n" +
      "\n" +
      "\n" +
      "   3. VOTRE STATUT\n" +
      "\n" +
      "3.1 Capacité juridique, âge : Pour vous connecter et utiliser le Site internet, Vous devez avoir :\n" +
      "- la pleine capacité de jouissance et d’exercice pour contracter avec Nous ;\n" +
      "- 18 ans révolus.\n" +
      "\n" +
      "3.2 Login de réseaux sociaux : FACEBOOK Vous permet de créer un lien entre votre compte SHISH  et des réseaux sociaux exploités par des Tiers. Si vous accédez à votre compte SHISH au travers d’un de ces réseaux, Vous Nous autorisez à accéder à certaines informations de votre profil sur le dit réseau social et à les utiliser conformément avec notre « Politique de confidentialité», et en accord avec les termes de politique de confidentialité du réseau social en cause.\n" +
      "\n" +
      "   4. INSCRIPTION AU SITE INTERNET\n" +
      "\n" +
      "Au cas où vous n’avez pas de compte client, Vous devez :\n" +
      "\n- cliquer sur l’onglet « Créer un Compte » Client,livreur,partenaire.\n" +
      "\n- saisir votre nom, prénom, adresse mail et mot de passe, puis valider l’inscription et accepter les conditions générales et la politique de confidentialité en cliquant sur « Envoyer » ;\n" +
      "\nUn courrier électronique Vous est automatiquement adressé pour notifier la prise en compte de votre inscription. Vous êtes invités à vérifier l’adresse électronique renseignée et vérifier votre boîte mail au cas où vous ne recevez pas de mail de confirmation.\n" +
      "Si Vous ne le recevez pas, Vous vous engagez à garder ces informations strictement confidentielles et à ne pas les communiquer à des tiers, afin d'éviter autant que possible tout risque d'intrusion dans votre compte client. SHISH ne pourra être tenue responsable d’aucune utilisation non autorisée du compte client par un tiers qui aurait eu accès à l’identifiant et au mot de passe correspondant, et notamment si l’identifiant et le mot de passe ont été communiqués à un tiers par Vous ou en raison de votre négligence.\n" +
      "En cas de perte ou d'oubli de votre mot de passe, Vous avez la possibilité de le mettre à jour et d'en choisir un nouveau en cliquant sur le lien « Mot de passe oublié ? » et en saisissant son adresse électronique. Vous recevrez alors un e-mail à l'adresse électronique indiquée, si elle est reconnue, Vous permettant de choisir un nouveau mot de passe.\n" +
      "Veuillez vous référer à notre Politique de confidentialité pour toute information sur la gestion de vos informations personnelles.\n" +
      "\n" +
      "   5. LICENCE\n" +
      "\n" +
      "5.1 Usage autorisé : Nous sommes propriétaires de tous les aspects du Site internet et le fait que Vous l'utilisiez ne signifie pas que Vous y possédiez quoi que ce soit. Nous vous autorisons à utiliser le Site internet dès lors que vous respectez les présentes CGU.\n" +
      "Nous Vous accordons une licence non exclusive, non transférable, limitée et ne pouvant faire l’objet d’aucune sous-licence pour accéder au Site internet pour un usage personnel et non commercial. Vos droits sont soumis à votre respect des CGU. Votre licence prend effet à la date à laquelle Vous utilisez le Site internet et se termine lorsque Vous cessez d'utiliser le Site ou que nous résilions votre licence, selon ce qui intervient en premier. Votre licence est immédiatement résiliée de plein droit si vous tentez de contourner toute mesure de protection technique utilisée en lien avec le Site internet ou si vous contrevenez d’une quelconque façon aux dispositions des présentes.\n" +
      "Nous nous réservons tous les droits, titres et intérêts dans le Site internet, y compris, mais sans s'y limiter, tous les droits d'auteur, marques de fabrique, secrets commerciaux, noms commerciaux, droits de propriété, brevets, titres, codes informatiques, effets audiovisuels, thèmes, personnages, noms de personnages, histoires, dialogues, décors, illustrations, effets sonores, œuvres musicales, et les droits moraux enregistrés ou non et toutes leurs applications.\n" +
      "Le Site Internet est protégé par les lois et traités en vigueur dans le monde entier. Sauf formellement autorisé par la législation obligatoire, le Site internet et ses contenus ne peuvent être copiés, reproduits ou distribués de quelque manière ou moyen que ce soit, en tout ou en partie, sans notre autorisation écrite préalable.\n" +
      "\n" +
      "5.2 Droits réservés : Nous nous réservons tous les droits qui ne Vous sont pas explicitement accordés.\n" +
      "\n" +
      "   6. ACCES AU SITE INTERNET\n" +
      "\n" +
      "6.1 Disponibilité d’accès au Site internet : Nous faisons le nécessaire afin de vous assurer une disponibilité d’accès au site 24H sur 24. Malgré cela, nous ne saurions être tenus pour responsable à aucun titre d’une interruption de cet accès quel qu’en soit le motif, quelle qu’en soit la durée.\n" +
      "\n" +
      "6.2 Suspension de l’accès : Pour des raisons techniques, de sécurité ou de maintenance, des coupures d’électricité ou tout autre motif valable, l’accès au Site internet peut être suspendu vis à vis d’un Utilisateur ou de tous, à tout moment et sans préavis quelconque.\n" +
      "\n" +
      "6.3 Informations sur la sécurité : Bien que nous prenions l’ensemble des dispositions requises par la loi pour protéger l’ensemble de vos informations sur notre Site, nous ne pouvons garantir que la transmission des données à notre Site internet soit parfaitement protégée. Cette transmission intervient à vos risques et périls. Veuillez vous référer à notre Politique de confidentialité pour toute information sur les mesures que nous prenons pour sécuriser vos informations personnelles.\n" +
      "\n" +
      "   7. DONNEES UTILISATEURS ET AVIS CLIENTS\n" +
      "\n" +
      "7.1 Généralités : Toute information autre que les coordonnées et détails relatifs à la personne de l’Utilisateur (informations couvertes par la Politique de confidentialité), sera considéré comme non confidentielle et libre au titre de tous droits de propriété intellectuelle (ci-après les « Informations Utilisateurs »). Sont considérées comme des Informations Utilisateurs, notamment, les avis clients adressés, les mails échangés avec le service clients, et tout fichier transmis àSHISH . Vous reconnaissez et garantissez que vous êtes titulaire de tous les droits d’utilisation ou tout autre droit sur ces contenus et que vous nous autorisez à les conserver et à les réutiliser. Vous acceptez en outre que nous n’ayons aucune responsabilité et aucune obligation quelconque au titre de ces contenus (textes, images, photos, sons) de restitution, de suppression, de contrôle ou de préservation, et que nous pouvons en faire tout usage qui nous semblerait approprié tel que copie partielle ou totale, reproduction, distribution, incorporation pour un usage commercial ou non commercial et ce qu’elle qu’en soit la forme.\n" +
      "Vous déclarez et garantissez que ces Informations Utilisateurs que vous nous transmettez ne contreviennent pas à l’une ou plusieurs des restrictions figurants aux articles 7.2 et 7.3 ci-dessous.\n" +
      "\n" +
      "7.2 Politique relative aux Données Utilisateurs : Ne peuvent être transmisent à notre Site internet toute information qui :\n" +
      "\n- Contreviendrait à des lois internationales ou nationales (notamment diffamation, injure, atteinte quelconque à la liberté d’expression...) ;\n" +
      "\n- Est illégale, ou fausse, ou frauduleuse ;\n" +
      "\n- Constituerait une publicité non autorisée, exagérée, inexacte ou tendancieuse ;\n" +
      "\n- Contiendrait tout virus, ou tout autre dispositif technique pouvant endommager le Site internet, le rendre non fonctionnel, ou tendant à le pirater ;\n" +
      "\n" +
      "7.3 Politique relative aux « Avis Clients » : en particulier, notamment, tout Avis Client déposé sur notre Site internet doit être conforme aux Conditions générales d’utilisation relatives aux avis figurant dans la rubrique « Déposer un avis » et ne devrons pas, en toute hypothèse :\n" +
      "\n" +
      "\n- Contenir toute affirmation pouvant constituer une diffamation, une injure ou un avis pouvant heurter la sensibilité de certains usagers ;\n" +
      "\n- Promouvoir, soutenir ou inviter à un comportement violent ou discriminatoire ;\n" +
      "\n- Atteindre aux droits de propriété intellectuelle ou au droit de propriété sur une marque d’un tiers ;\n" +
      "\n- Constituer la violation d’une clause contractuelle ou d’une obligation légale de confidentialité ;\n" +
      "\n- Promouvoir toute activité illégale, non autorisée ou dangereuse ;\n" +
      "\n- Présenter un cas de violation de la vie privée d’autrui ;\n" +
      "\n- Donner une impression que cet avis résulte de nos propres services ou nous engage ;\n" +
      "\n- Donner un avis au nom d’une autre personne en usurpant une identité, ou donnant une fausse idée de vos relations avec une tierce partie.\n" +
      "\n- Les avis clients peuvent également être retirés parce qu’ils portent sur le service « Nom de votre société » et non pas sur l’entreprise concerné, parce qu’ils résultent de personnes n’ayant pas passé de commande, ou reposent sur des circonstances trop imprécises pour que l’avis soit utile aux autres usagers.\n" +
      "\n" +
      "7.4 Retrait des Avis Client / Responsabilité: Tout avis qui nous est signalé comme non conforme à notre politique visée aux articles 7.1. à 7.3 sera immédiatement retiré et sans préavis. Nous ne prenons en outre aucune responsabilité quelconque de surveillance des avis clients et l’Utilisateur reste seul responsable des conséquences légales ou dommageables des Informations Utilisateurs et avis clients qu’il nous transmet et/ou visibles sur le Site vis à vis des tiers. Les avis sont retirés mais ne sont jamais modifiés.\n" +
      "\n" +
      "7.5 Garantie: Relativement à toute Information Utilisateur ou tout Avis Client dont Vous êtes l’émetteur, Vous acceptez de nous garantir de toute perte, préjudice et/ou de toute mise en cause (et tout coût qui serait induit) qui résulterait d’action(s) légale(s) entreprise(s) par toute tierce partie qui se fonderait ou trouverait sa cause dans cette Information Utilisateur ou Avis Client et qui nous aurait été transmise en violation des présentes CGU.\n" +
      "\n" +
      "7.6 Demande de communication : Vous êtes informés et Vous acceptez que nous coopérerions, le cas échéant, et à leur requête, dans les cadres légaux applicables, à toute demande de communication avec toute autorité administrative ou judiciaire compétente, qui solliciterait la révélation de l’origine et de l’identité de l’émetteur d’une Information Utilisateur ou d’un Avis Client dont nous serions destinataires et qui contreviendrait à une obligation légale ou réglementaire quelconque, et Vous acceptez dès à présent que notre responsabilité ne pourra être engagée à aucun titre en cas de communication à une telle autorité administrative ou judiciaire.\n" +
      "Consultez attentivement nos Conditions générales d’utilisation relatives aux avis pour des informations plus complètes sur les Avis Clients.\n" +
      "\n" +
      "   8. REFERENCEMENT ET CLASSEMENT DES OFFRES\n" +
      "\n" +
      "8.1 Nous classons et référençons les offres des entreprises partenaires selon les critères suivants : proximité géographique avec la localisation du consommateur, note de confiance obtenues par les entreprises partenaires. Les entreprises devenues récemment partenaires peuvent également figurer en tête de classement dans le but de faire découvrir leur offre.\n" +
      "\n" +
      "8.2 Certaines offres des entreprises partenaires peuvent figurer en tête de classement en raison d’une rémunération versée par ladite entreprise partenaire à SHISH  La mention « A découvrir » ou « Découvrez » indiquant l’existence d’une telle rémunération est alors inscrite à proximité de l’offre.\n" +
      "\n" +
      "8.3 Des informations supplémentaires sur la manière dont nous classons les entreprises partenaires peuvent être trouvées ici : www.shish.fr\n" +
      "\n" +
      "   9. LIENS SORTANTS OU VENANT D’AUTRES SITES INTERNET\n" +
      "\n" +
      "9.1 Sites internet de tiers : Les liens sortant du Site internet vers d’autres sites internet ou pages sont fournis à seule fin de confort de l’Utilisateur. En cliquant sur ces liens, vous sortez du « site internet ». Nous ne procédons à aucun contrôle des sites de tiers et nous déclinons toute responsabilité relative à ces sites internet de tiers, leur disponibilité, leur sécurité et leur contenu. Nous ne garantissons en aucun cas les éditeurs de tels sites et n’acceptons aucune responsabilité liée à l’utilisation de tels sites. Si vous décidez d’être redirigé vers un site de tiers, vous le faîte sous votre unique responsabilité.\n" +
      "\n" +
      "9.2 Autorisation de créer des liens : Vous pouvez mettre en place un lien entre la page principale du site www.hish.fr et votre propre site, sous réserve que ce lien repose sur une intention loyale, non lucrative, qu’il soit conforme à l’ensemble des dispositions légales applicables, notamment, en ne portant aucune atteinte à notre clientèle et en ne nuisant pas ou en ne profitant pas de notre réputation.\n" +
      "\n" +
      "\n" +
      "   10. DECLINAISON DE  RESPONSABILITE\n" +
      "\n" +
      "Nous Nous efforçons de fournir sur le Site internet une information exacte, mais nous ne pouvons garantir qu’elle est vraie, ni qu’elle est complète. Nous pouvons modifier à tout moment et sans préavis le contenu de ces informations, leur fonctionnalité, le contenu de nos services et de nos offres. Le contenu informatif peut ne pas être parfaitement actualisé, mais Nous ne prenons aucun engagement à ce titre, et déclinons toute responsabilité. Les Avis Clients ou autre contenu émanant des Utilisateurs ne constituent en aucun cas une information objective que Nous avons vérifiée et qui Nous engage.\n" +
      "\n" +
      "   11. FIN DES RELATIONS\n" +
      "\n" +
      "Nous pouvons mettre un terme ou suspendre votre droit d’utilisation du Site internet, sur simple notification par e-mail et/ou par écrit, si nous estimons que :\n" +
      "\n- Vous avez fait usage du Site internet en contradiction avec l’article 6 (Licence) ;\n" +
      "\n- Vous avez établi des Avis Clients ou toute autre Information Utilisateur en violation des articles 7.2. ou/et 7.3.\n" +
      "\n- Vous avez violé l’article 9.2 (Liens avec d’autres sites) ;\n" +
      "\n- Vous avez violé toute autre règle importante posée par les présentes CGU ou des affaires.\n" +
      "\n" +
      "   12. COMMUNICATIONS ECRITES - ATTESTATION\n" +
      "\n" +
      "12.1 Vous acceptez, en utilisant le Site internet que l’essentiel de nos communications soit échangé sous format électronique. Nous Vous contacterons par e-mail ou diffuserons toute information générale sur le Site internet. Vous acceptez expressément que l’ensemble des échanges, contrat, notice d’information, envoi de factures soit faite de manière dématérialisée.\n" +
      "\n" +
      "12.3 Les informations contractuelles feront l'objet d'un courrier électronique (e-mail) de confirmation. En conservant cet email et en l'imprimant, Vous détenez une preuve de votre inscription que Nous Vous invitons à conserver.\n" +
      "\n" +
      "12.3 Vous acceptez que les copies numériques des échanges entre les parties conservées sur un disque de stockage conforme aux normes applicables constituent une preuve suffisante des relations entre les parties.\n" +
      "\n" +
      "   13. CAS DE FORCE MAJEURE\n" +
      "\n" +
      "13.1 Nous déclinons toute responsabilité dans le cas où Nous serions dans l’incapacité temporaire ou permanente d’exécuter totalement ou partiellement les services accessibles sur le Site internet en raison d’un événement échappant à notre contrôle, imprévisible et irrésistible constituant un cas de force majeure tel que défini par la loi (« Cas de force majeure »).\n" +
      "\n" +
      "13.2 Nous Vous préviendrons dès la survenance d’un Cas de force majeure. L’exécution d’une quelconque obligation prévue par les présentes CGU sera suspendue de plein droit pendant toute la période d’occurrence du Cas de force majeure et se poursuivra tant que ces circonstances existent et à l’issue de cette période, durant un délai raisonnable pour permettre une reprise normale de l’exécution des prestations. Nous Nous efforcerons, néanmoins, de maintenir nos services autant que possible dans des situations apparentées à des Cas de force majeure mais ne rendant pas strictement impossible l’exécution de nos prestations.\n" +
      "\n" +
      "   14. DISPOSITIONS SUPPLÉMENTAIRES\n" +
      "\n" +
      "14.1 Politique de confidentialité: Nous nous engageons pour protéger vos informations personnelles et assurer la sécurité de ces informations. Vous pouvez consulter les détails de cette politique de confidentialité et de respect de la vie pivée.\n" +
      "   15.  \n" +
      "14.2 Autres Dispositions : Nous vous invitons également à consulter notre « Politique d'Utilisation des Cookies » pour toute information concernant l'usage des cookies ou technologies similaires sur notre site/application mobile. Toute ces dispositions font partie intégrante de nos Conditions Générales, même si elles sont rassemblées dans des chapitres séparés afin d’en assurer une meilleur visibilité.\n" +
      "\n" +
      "14.3 Nullité : Au cas où une ou plusieurs clauses des présentes était jugée comme nulle ou non opposable par une juridiction compétente ou par un texte législatif ou réglementaire, cette disposition sera supprimée sans que la validité ou l’opposabilité des autres dispositions des présentes n’en soient affectées, et les parties s'entendront pour la remplacer par une autre juridiquement valable, à moins qu'une telle nullité ou inopposabilité n'affecte la substance même des présentes ou ne modifie profondément son économie.\n" +
      "\n" +
      "14.4 L’intégralité des accords : Les CGU constituent, avec tout document qu’elles visent l’intégralité des conditions qui s’appliquent à nos relations avec tout usager du Site internet et elles s’appliquent de préférence à toute autre disposition antérieure, toute discussion ou accord antérieur, tous pourparlers, correspondance, négociation qui seraient intervenus avant la présente diffusion des CGU ou toutes conditions générales de services ou d’usage antérieures.\n" +
      "\n" +
      "14.5 Non-renonciation : Le fait pour l’une ou l’autre des parties de ne pas invoquer l’un quelconque des droits que lui confèrent les présentes ne sera pas considéré comme valant renonciation à ce droit et n’empêchera pas cette partie d’en invoquer l’application ultérieurement et à tout moment.\n" +
      "\n" +
      "14.6 Caractère intuitu personae : Aucun droit et aucune obligation résultant des présentes ne peuvent être transférés, cédés, transmis à tout tiers, par un usager sans notre consentement préalable et exprès. Réciproquement, nous ne pouvons céder le présent contrat à l’exception d’une filiale de notre société mère, d’une société ou encore d’une société commune à laquelle Nous serions appelés à participer.\n" +
      "\n" +
      "   16. LOI APPLICABLE ET COMPETENCE JURIDICTIONNELLE\n" +
      "\n" +
      "l’ensemble des présentes CGU sont soumises au droit français.\n" +
      "\n" +
      "En tant que consommateur, vous bénéficierez de toute disposition impérative de la loi du pays dans lequel vous résidez. Rien dans les présentes CGU, y compris le paragraphe ci-dessus, n'affecte vos droits en tant que consommateur de vous prévaloir de ces dispositions impératives du droit local.\n" +
      "\nEn cas de difficulté, Vous pouvez contacter le Service Client à l’adresse suivante : www.shish.fr  \n" +
      "\n" +
      "Dans un tel cas, Vous pouvez contacter la plateforme SHISH via \n" +
      "\n" +
      "- www.shish.fr ; ou\n" +
      "\n" +
      "\n" +
      "Vous devez informer sans délai SHISH  de cette demande.\n" +
      "\n" +
      "Chacune des parties est libre d’accepter ou de rejeter la solution proposée et, si nécessaire, de porter la demande devant les tribunaux compétents.\n" +
      "\n" +
      "En outre, la Commission Européenne a mis en place une plateforme en ligne de résolution des différends à laquelle le Client consommateur peut accéder:\n" +
      "https://webgate.ec.europa.eu/odr\n" +
      "\nSi le Client agit en qualité de professionnel, tout litige auquel les présentes CGU pourraient donner lieu sera réglé amiablement et si cela n’est pas possible dans un délai d’un (1) mois, pourra être porté devant le Tribunal de commerce de Paris, auquel les parties attribuent compétence exclusive.\n" +
      "\n" +
      "En tant que consommateur, si vous résidez dans un autre État membre de l'Union européenne, vous pouvez intenter une action en justice concernant les présentes CGU devant les tribunaux français ou les tribunaux de votre pays d'origine.\n" +
      "\n" +
      "\n\n" +
      "\nMentions légales\n" +
      "\nEdition du site\n" +
      "\nwww.shish.fr  est un site édité par la société www.eldev.fr\n" +
      "\nSHISH est une SAS au capital de 100 euros, dont le siège social est à Corbeil-Essonnes immatriculée au registre du commerce et des sociétés de Evry.\n" +
      "\nNuméro de téléphone :06.50.73.08.61\n" +
      "\n" +
      "\n" +
      "Directeur de la publication : Youssouf  Djerar\n" +
      "\nPropriété Intellectuelle\n" +
      "\nL'ensemble de ce site relève de la législation française et internationale sur le droit d'auteur et la propriété intellectuelle. Tous les droits de reproduction sont réservés, y compris les représentations iconographiques et photographiques. La reproduction, adaptation et/ou traduction de tout ou partie de ce site sur un support quel qu'il soit, est formellement interdite sauf autorisation expresse du Directeur de la publication.\n" +
      "\nModification du site\n" +
      "\nL'équipe éditoriale se réserve le droit de modifier ou de corriger le contenu de ce site et de ces mentions légales à tout moment et ceci sans préavis.\n" +
      "\nHébergeur\n" +
      "\nLe site www.shish.fr est hébergé par la société godady.com \n" +
      "\nInformations sur le règlement en ligne des litiges conformément à l'art. 14 paragr. 1 du RLL (Règlement en Ligne des Litiges) :\n" +
      "\nLa Commission Européenne permet aux consommateurs de résoudre les litiges en ligne sur l'une de ses plateformes, conformément à l'art. 14 paragr. 1 du RLL. La plateforme (https://webgate.ec.europa.eu/odr/main/index.cfm?event=main.home.show&lng=FR) agit comme un site où les consommateurs peuvent essayer des régler hors tribunal des litiges survenus lors d'achats de biens ou services en ligne.\n" +
      "\n\n\n\nPolitique de confidentialité et de protection de la vie privée\n" +
      "\n" +
      "Introduction\n" +
      "\nChez SHISH, nous nous sommes engagés à protéger les données personnelles de tous les visiteurs qui accèdent à notre site internet ou services via tout(e) application, plateforme ou dispositif mobile (collectivement, les « Services »).\n" +
      "\nL’actuelle politique de confidentialité (« Politique de Confidentialité ») explique comment SHISH et nos associés (collectons, partageons et utilisons vos données personnelles. Des informations sont disponibles quant à comment exercer vos droits quant à la protection de votre vie privée. En utilisant nos Services vous consentez à ce que SHISH  utilise vos données personnelles de la manière décrite dans la présente Politique de Confidentialité. Les termes « nous », « nos » ou « notre » sont chacun destinés à faire référence à SHISH  et tout terme n’étant pas défini dans la présente Politique de Confidentialité est défini dans nos Conditions.\n" +
      "\n" +
      "Résumé :\n" +
      "\n" +
      "Ci-dessous sont résumés les points clés de notre Politique de Confidentialité. \n" +
      "\n" +
      "Données vous concernant que nous collectons et pourquoi.  Vous trouverez ci-après les catégories générales de données personnelles que nous pouvons collecter vous concernant et à quelles fins :\n" +
      "\n" +
      "\n" +
      "       a. Informations que vous communiquez volontairement : \n" +
      "\n" +
      "● Les informations d’enregistrement lorsque vous créez un compte afin que nous puissions :\n" +
      "\n" +
      "     i. créer votre compte pour que vous puissiez passer des Commandes en vertu de nos Conditions ;\n" +
      "\n" +
      "     ii. vous identifier lorsque vous vous connectez à votre compte ;\n" +
      "\n" +
      "     iii. vous contacter afin d’avoir votre point de vue sur nos Services ; et\n" +
      "\n" +
      "     iv. vous informer des modifications ou mises à jour de nos Services.\n" +
      "\n" +
      "● Les informations sur les transactions lorsque vous passez une Commande auprès d’un de nos partenaires afin de :\n" +
      "\n" +
      "     v. traiter votre Commande et vous la facturer (remarque : nous ne stockons, en aucun cas, vos informations de carte de crédit dans nos systèmes) ;\n" +
      "\n" +
      "     vi. communiquer votre Commande au partenaire ;\n" +
      "\n" +
      "     vii. vous envoyer les actualisations du statut de votre Commande ;\n" +
      "\n" +
      "     viii. répondre à vos demandes et questions concernant votre Commande et résoudre les problèmes ;\n" +
      "\n" +
      "     ix. réaliser une analyse et recherche afin de développer et améliorer nos Services ; et\n" +
      "\n" +
      "     x. vous protéger ainsi que les Services en tentant de détecter et prévenir la fraude et les autres actes qui pourraient enfreindre nos Conditions ou politiques applicables aux Services.\n" +
      "\n" +
      "● Informations concernant vos préférences publicitaires afin que nous puissions :\n" +
      "\n" +
      "     xi. vous envoyer des publicités personnalisées sur nos produits ou services.\n" +
      "\n" +
      "● Commentaire sur vos points de vue concernant nos Services afin de :\n" +
      "\n" +
      "     xii. répondre à vos questions ou demandes ;\n" +
      "\n" +
      "     xiii. publier des avis que vous nous soumettez concernant nos partenaires et services ; et\n" +
      "\n" +
      "     xiv. conduire une analyse et recherche afin d’améliorer et de développer nos Services.\n" +
      "\n" +
      "\n" +
      "       b. Informations que nous collectons automatiquement\n" +
      "\n" +
      "● Les informations relatives à l’activité afin que nous puissions :\n" +
      "\n" +
      "     i. vous fournir une meilleure expérience ;\n" +
      "\n" +
      "     ii. vous permettre d’accéder à l’historique de vos Commandes et à vos préférences ; et\n" +
      "\n" +
      "     iii. fournir d’autres services à votre demande.\n" +
      "\n" +
      "● Cookies et technologies similaires afin que nous puissions :\n" +
      "\n" +
      "     iv. mesurer et analyser l’utilisation et l’efficacité de nos Services ;\n" +
      "\n" +
      "     v. personnaliser et optimiser la cible de la publicité pour nos Services dans d’autres sites web et plateformes ; et\n" +
      "\n" +
      "     vi. fournir des services géolocalisés si vous choisissez de partager votre géolocalisation.\n" +
      "\n" +
      "\n" +
      "       c. Informations que nous obtenons de sources tierces\n" +
      "\n" +
      "● Rapports analytiques et études de marché afin de :\n" +
      "\n" +
      "     i. mesurer la performance des campagnes marketing de nos Services ; et\n" +
      "\n" +
      "     ii. mieux comprendre vos préférences afin que nous puissions personnaliser nos campagnes marketing et Services en conséquence.\n" +
      "\n" +
      "Nous traitons les informations que vous fournissez volontairement, les informations que nous collectons automatiquement et les informations que nous obtenons de sources tierces afin de constamment améliorer nos Services. Nous pouvons ainsi vous permettre de trouver plus facilement le produit que vous souhaitez, lorsque vous le souhaitez, indépendamment du dispositif que vous décidez d’utiliser ou de l'emplacement auquel vous vous trouvez.\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "Condition d’âge\n" +
      "Notre site web n'est pas destiné aux personnes âgées de moins de 16 ans, et nous n'avons pas l'intention de collecter les données personnelles des visiteurs du site web qui sont âgés de moins de 16 ans. Nous conseillons donc aux parents de surveiller les activités en ligne de leurs enfants, afin d'éviter que leurs données personnelles ne soient collectées sans leur consentement. Si vous estimez que nous avons collecté des données personnelles d'un mineur sans son consentement, veuillez nous contacter à l'adresse afin que nous puissions prendre les mesures appropriées. Conformément à nos conditions générales de vente, seules les personnes âgées de 18 ans ou plus peuvent passer des commandes sur notre site web.\n" +
      "\n" +
      "\n" +
      "   2. Avec qui partageons-nous vos données personnelles ?\n" +
      "\n" +
      "Nous pouvons partager vos données personnelles avec les destinataires suivants (et le cas échéant, nous nous assurons d’avoir mis en place la sécurité et les garanties contractuelles appropriées pour les protéger) :\n" +
      "\n" +
      "     i. Partenaires auprès desquels vous avez passé une Commande en vue de son traitement et de la livraison ;\n" +
      "\n" +
      "     ii. Les tiers qui supportent nos Services (ex. partenaires pour le marketing ou les promotions dans les secteurs de tabac,Gôut et loisirs en fonction de vos préférences) ;\n" +
      "\n" +
      "     iii. Tout organisme d’application de la loi ou réglementaire, agence gouvernementale, tribunal ou autre tiers lorsque nous considérons que la divulgation est nécessaire en vertu de la législation ou des réglementations applicables ;\n" +
      "\n" +
      "     iv. Les entités ayant de nouveaux propriétaires ou réorganisées en cas de restructuration d’entreprise, vente, achat ou coentreprise affectant notre activité ;\n" +
      "\n" +
      "     v. Toute autre personne à condition que vous y ayez consenti.\n" +
      "\n" +
      "Nous ne vendrons, distribuerons ou ne partagerons autrement, en aucun cas, vos données personnelles, sauf si nous avons obtenu votre autorisation.\n" +
      "\n" +
      "\n" +
      "   3. Fondement légal du traitement des données personnelles\n" +
      "\n" +
      "SHISH  s’assurera toujours d’avoir une base légale pour collecter et utiliser vos données personnelles. La base légale sur laquelle nous nous appuyons changera en fonction du type d’informations et du contexte dans lequel nous les collectons.\n" +
      "\n" +
      "La raison principale de collecte et d’utilisation de vos données personnelles est d’exécuter notre contrat avec vous (c’est-à-dire, s’assurer que vous puissiez recevoir votre Commande quand et où vous le souhaitez), mais nous pouvons également les traiter lorsque ceci relève de nos intérêts commerciaux légitimes.\n" +
      "\n" +
      "\n" +
      "\n" +
      "   4. Transferts internationaux des données\n" +
      "\n" +
      "Nous pouvons transférer vos données personnelles aux pays hors de votre pays de résidence, aux autres pays où (SHISH  ou nos prestataires de services exercent leur activité. Les lois sur la protection des données de ces pays peuvent être différentes des lois de votre pays, SHISH veille à mettre en œuvre des garanties appropriées afin de protéger vos données personnelles dans ces pays conformément à cette Politique de Confidentialité.\n" +
      "\n" +
      "   5. Garantie de sécurité des données\n" +
      "SHISH accorde une grande importance à la protection de vos données personnelles contre tout accès non autorisé et tout traitement illégal, perte, destruction ou dommage accidentel(le). Nous mettons en œuvre de mesures techniques et organisationnelles afin de garantir la sécurité de ces informations.\n" +
      "\n" +
      "\n" +
      "   6. Conservation des données\n" +
      "\n" +
      "SHISH conserve vos données personnelles pas plus de temps que nécessaire pour satisfaire aux finalités décrites dans la présente Politique de Confidentialité. Nous pouvons également conserver certains éléments de vos données personnelles pour une période ultérieure à votre suppression ou désactivation de votre compte pour nos opérations légitimes telles que la tenue des dossiers et le respect de nos obligations légales. Lorsque nous conservons nos informations, nous le faisons conformément au droit applicable.\n" +
      "\n" +
      "\n" +
      "   7. Vos droits de protection des données\n" +
      "\n" +
      "Vous pouvez accéder à votre compte à tout moment afin de consulter et actualiser vos données personnelles. Vous pouvez également nous contacter afin de nous demander de supprimer vos données personnelles, de limiter leur traitement ou de demander à ce qu’elles soient transmises à un tiers. Vous pouvez vous désabonner des communications marketing que nous vous envoyons en utilisant la fonctionnalité « se désabonner » dans toute communication marketing que nous vous envoyons ou en modifiant votre profil en conséquence.\n" +
      "\n" +
      "\n" +
      "   8. Liens vers les sites tiers\n" +
      "\n" +
      "Nos sites web peuvent, à l’occasion, contenir des liens vers ou depuis des sites web tiers (par exemple, ceux de nos réseaux partenaires, annonceurs et sociétés affiliées). Si vous suivez ces liens, sachez que SHISH n’est pas responsable de ces sites web qui ont leurs propres politiques de confidentialité.\n" +
      "\n" +
      "\n" +
      "   9. Mises à jour de l’actuelle Politique de Confidentialité\n" +
      "\n" +
      "Nous pouvons mettre à jour, à l’occasion, cette Politique de Confidentialité en réponse aux modifications légales, techniques ou commerciales. Nous vous encourageons à consulter régulièrement cette page afin de voir les dernières informations sur nos pratiques de confidentialité.\n" +
      "\n" +
      "\n" +
      "   10. Comment nous contacter?\n" +
      "\n" +
      "Si vous avez la moindre question ou préoccupation concernant cette Politique de Confidentialité, n’hésitez pas à nous contacter. ……………………………..\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "\n" +
      "Informations additionnelles\n" +
      "   1. Informations vous concernant que nous collectons et pourquoi\n" +
      "\n" +
      "Les informations que nous pouvons collectées vous concernant à l’étranger tombent dans les catégories suivantes :\n" +
      "\n" +
      "\n" +
      "       a. Informations que vous communiquez volontairement\n" +
      "\n" +
      "Certaines parties de nos Services peuvent vous demander de fournir volontairement des données personnelles.\n" +
      "\n" +
      "Par exemple :\n" +
      "\n" +
      "     ▪ Informations d’enregistrement : Lorsque vous créez un compte, signez ou remplissez des formulaires sur les Services, nous collectons des informations vous concernant incluant vos nom, adresse, numéro de téléphone, adresse électronique et le mot de passe que vous créez.\n" +
      "     ▪ Informations sur les transactions : Nous collectons des informations concernant vos Commandes, incluant les informations de paiement (ex. votre numéro de carte de crédit) en utilisant les services sécurisés de nos processeurs de paiement. Les opérations de paiement sont confiées à nos prestataires de service de paiement et nous ne stockons pas vos informations de carte de crédit dans nos systèmes. Nous collectons également les informations de livraison (ex. votre adresse physique) afin de traiter chaque Commande.\n" +
      "     ▪ Informations concernant vos préférences publicitaires : Nous collectons des informations concernant vos préférences pour recevoir des publicités, service auquel vous pouvez vous abonner ou vous désabonner à tout moment.\n" +
      "     ▪ Commentaires : Lorsque vous publiez des messages ou avis sur les Services ou lorsque vous nous contactez, par exemple avec une question, un problème ou commentaire, nous collectons des informations vous concernant y compris votre nom et le contenu de votre demande. Si vous contactez nos équipes de service client, nous enregistrerons et garderons une trace de votre conversation à des fins de qualité et de formation et afin d’aider à la résolution de vos demandes.\n" +
      "\n" +
      "       b. Informations que nous collectons automatiquement\n" +
      "\n" +
      "Lorsque vous accédez à nos Services, nous pouvons collecter certaines informations automatiquement depuis votre dispositif. Dans certains pays, y compris les pays européens, ces informations peuvent être considérées comme des données personnelles en vertu du droit applicable en matière de protection des données.\n" +
      "\n" +
      "Par exemple :\n" +
      "\n" +
      "     ▪ Information sur l’activité : Nous collectons des informations sur votre utilisation des Services et des informations vous concernant à partir du contenu que vous créez et des notifications ou messages que vous publiez ou envoyez tout comme de vos recherches, de ce que vous regardez et de vos discussions.\n" +
      "     ▪ Cookies et technologies similaires : Nous utilisons des cookies et une technologie de suivi similaire afin de collecter et utiliser les données personnelles vous concernant (ex. votre adresse de Protocole Internet (IP), l’identifiant de votre dispositif, votre type de navigateur et quand, à quelle fréquence et combien de temps vous interagissez avec les Services), y compris afin de faciliter la publicité basée sur vos intérêts.\n" +
      "Pour obtenir de plus amples informations sur les types de cookies et technologies similaires que nous utilisons, pourquoi, et comment vous pouvez contrôler ces technologies, consultez notre Politique en matière de Cookies.\n" +
      "\n" +
      "\n" +
      "       c. Informations que nous obtenons de sources tierces\n" +
      "\n" +
      "Nous pouvons recevoir, occasionnellement, des données personnelles de la part de sources tierces, y compris des réseaux publicitaires, mais uniquement si nous avons vérifié que ces tiers ont obtenu votre consentement au traitement des informations ou sont autrement légalement autorisés ou tenus de partager vos données personnelles avec nous. Ces informations peuvent inclure votre groupe démographique probable.\n" +
      "\n" +
      "Par exemple :\n" +
      "\n" +
      "     ▪ Rapports analytiques et études de marché : Nous collectons des informations auprès de nos sociétés affiliées tierces concernant la manière dont vous répondez et réagissez à nos campagnes marketing afin que nous puissions personnaliser notre marketing et nos Services en conséquence.\n" +
      "     ▪ Nous pouvons également recevoir des informations agrégées sous la forme de segments d’audience de la part de sources tierces afin d’afficher des publicités ciblées sur des biens numériques exploités par des organisations telles que Facebook et Google.\n" +
      "\n" +
      "       d.  Notre utilisation des informations collectées\n" +
      "Nous pouvons utiliser ces informations par exemple, de la manière suivante :\n" +
      "\n" +
      "Informations que vous communiquez volontairement\n" +
      "\n" +
      "     • Informations d’enregistrement\n" +
      "Les informations d’enregistrement que vous fournissez lorsque vous créez un compte SHISH  nous permettent de vous donner accès aux Services et de vous les fournir [selon nos Conditions]. Nous utilisons également ces informations pour authentifier votre accès aux Services, vous contacter pour obtenir vos points de vue et vous communiquer les modifications ou mises à jour importantes de nos Services.\n" +
      "\n" +
      "     • Informations sur les transactions\n" +
      "Les informations sur vos transactions (tels que les produits que vous ajoutez dans votre panier) nous permettent de traiter votre Commande et de vous envoyer une facture exacte. Elles nous aident également, ainsi que tout partenaire chez lequel vous passez commande, à vous contacter si nécessaire.\n" +
      "SHISH peut vous contacter par courriel, téléphone ou SMS afin de vous communiquer les mises à jour de votre statut ou autres informations ou résoudre les problèmes avec votre compte ou commande. Un partenaire peut vous contacter par téléphone ou SMS afin de vous fournir des mises à jour de votre statut ou autres informations concernant votre Commande.\n" +
      "\n" +
      "Dans la mesure des disponibilités, lorsque vous payez pour votre Commande avec un fournisseur de services de paiement mobile ou de portefeuille numérique (tel que Stripe ou Paypal), nous pouvons vous envoyer des informations sur les transactions via des courriels de confirmation ou SMS à l’adresse de courrier électronique ou au numéro de téléphone enregistré auprès de ce prestataire de services (au cas où cela est requis par ces prestataires).\n" +
      "\n" +
      "Certains partenaires sur notre plateforme utilisent nos sociétés de livraison tierces ; ces sociétés peuvent utiliser vos informations pour vous communiquer des mises à jour du statut de la livraison de votre Commande.\n" +
      "\n" +
      "Nous analyserons également les informations sur les transactions réalisées et les Commandes dûment livrées sur la base de la correspondance des données ou d’une analyse statistique afin que nous puissions administrer, supporter, améliorer et développer notre activité et nos Services. Nos analyses nous aident également à détecter et prévenir la fraude ou les autres activités ou actes illégaux interdits par nos Conditions ou toute politique applicable aux Services.\n" +
      "\n" +
      "\n" +
      "     • Informations concernant vos préférences publicitaires\n" +
      "SHISH  peut vous envoyer des publicités, si la loi l’autorise, par la poste, par courriel, [téléphone], mobile (c’est-à-dire, SMS, messagerie d’application et notifications push) concernant nos produits ou Services.\n" +
      "\n" +
      "Si vous avez donné votre consentement, nous pouvons partager vos données personnelles avec des tiers (ex. d’autres sociétés) dans d’autres secteurs (tels que les tabac, les Goût et divertissements) de sorte qu’ils peuvent vous parler de produits ou services pouvant vous intéresser.\n" +
      "\n" +
      "Si vous ne souhaitez pas utiliser vos données de cette manière ou changez généralement d’avis concernant la réception de toute forme de communications marketing, vous pouvez vous désabonner à tout moment en utilisant la fonctionnalité se désabonner concernant la communication que vous recevez ou en modifiant votre profil en conséquence. Vous pouvez également opter pour les notifications push au niveau du dispositif (ex. par la configuration de votre iOS). Si vous choisissez de vous désabonner de nos publicités, nous conserverons un dossier de vos préférences afin de ne pas vous déranger avec des publicités non sollicitées à l’avenir.\n" +
      "\n" +
      "     • Commentaires et avis\n" +
      "Si vous nous soumettez des commentaires, nous les utiliserons pour répondre à vos questions ou demandes, pour fournir l’assistance client et résoudre tout problème avec vos Commandes et les Services. Nous publierons sur notre plateforme les avis que vous nous envoyez concernant les partenaires et nos Services en général et nous analyserons également vos commentaires pour améliorer et développer nos Services et afin d’améliorer votre expérience.\n" +
      "\n" +
      "Informations que nous collectons automatiquement\n" +
      "\n" +
      "Lorsque vous accédez à nos Services, nous pouvons collecter certaines informations automatiquement depuis votre dispositif comme votre adresse IP, adresse MAC ou l’identifiant du dispositif. Dans certains pays, y compris l’Europe, ces informations peuvent être considérées comme des données personnelles en vertu du droit applicable en matière de protection des données.\n" +
      "\n" +
      "     • Information sur l’activité\n" +
      "Nous analysons vos habitudes d’achat et la manière dont vous interagissez avec nos Services afin de pouvoir vous suggérer des options de nouveaux partenaires que vous aimeriez, selon nous, tester. Si vous décidez de partager votre géolocalisation avec nous, nous pouvons utiliser ces informations pour vous montrer le contenu adapté à votre localisation ; ces informations aideront également à faciliter la livraison effective et rapide de votre Commande. Nous pouvons également vous fournir du contenu et des publicités personnalisés sur la base de vos interactions précédentes avec nos Services et nos connaissances de vos préférences sur la base de votre historique d’utilisation et d’achat concernant les Services.\n" +
      "Nous vous permettons d’accéder à l’historique de vos Commandes afin que vous puissiez facilement commander de nouveau chez nos partenaires qui sont vos favoris. Nous pouvons également collecter des informations sur votre interaction avec nos courriels et autres formes de communication.\n" +
      "\n" +
      "     • Cookies et technologies semblables\n" +
      "Nous travaillons avec des sociétés affiliées publicitaires envoyant des publicités sur nos Services sur les sites et services de tiers. Certains de ces réseaux utilisent des cookies nous permettant d’afficher des publicités personnalisées en fonction de vos intérêts basés sur votre activité de navigation sur internet.\n" +
      "\n" +
      "Tout comme de nombreux sites internet et services en ligne, nous utilisons des cookies et autres technologies pour tenir un dossier de votre interaction avec nos Services. Les cookies nous aident également à gérer un ensemble d’options et de contenu tout comme stocker les recherches et représenter vos informations au moment de la Commande. Pour obtenir de plus amples informations sur les types de cookies et technologies similaires que nous utilisons, pourquoi, et comment vous pouvez contrôler ces technologies, consultez notre Politique en matière de Cookies.\n" +
      "\n" +
      "Informations que nous obtenons de sources tierces\n" +
      "\n" +
      "     • Rapports analytiques et études de marché\n" +
      "Nous analysons les informations que nous collectons auprès de nos prestataires de services tiers (tels que Google, Facebook, Amazon et autres sociétés affiliées) afin de comprendre comment vous réagissez à nos Services et publicités (ex. si vous avez cliqué sur l’une de nos publicités). Ceci nous aide à comprendre vos préférences et à vous recommander des Services conformes à vos intérêts.\n" +
      "\n" +
      "   . Avec qui partageons-nous vos données personnelles ?\n" +
      "\n" +
      "Lorsque nous vous fournissons les Services, en fonction des circonstances, nous pouvons partager vos données personnelles avec les entités suivantes :\n" +
      "\n" +
      "       . Les partenaires auprès de qui vous passez Commande afin qu’ils puissent la traiter et vous la livrer.\n" +
      "\n" +
      "       . Les sociétés membres du groupe de sociétés SHISH  (c’est-à-dire, nos filiales et sociétés affiliées- ces sociétés agissent pour nous et traitent vos données personnelles pour les finalités énoncées dans la présente Politique de Confidentialité.\n" +
      "\n" +
      "       . Les tiers qui exercent diverses activités de promotion et de support de nos Services. Cela inclut les partenaires de mise en œuvre, les agents d’assistance client à l’étranger, le site web, le support de l’application et les fournisseurs d’hébergement, les prestataires de services marketing, les partenaires eCRM tels que Salesforce qui gère nos courriels marketing et notifications push, les sociétés qui vous envoient des textos lorsque votre Commande est en cours d'acheminement, les sociétés de livraison qui vous livrent votre Commande, les sociétés d’étude de marché, les sociétés d’étude de la satisfaction des clients et les fournisseurs de traitement des paiements qui traitent les opérations de paiement par carte bancaire - un quelconque de ces tiers peut être dans le pays de résidence ou non.\n" +
      "\n" +
      "       . Comme il est mentionné à l’article 2 ci-dessus, nous pouvons partager vos informations avec des tiers (ex. des secteurs de tabac, des gôut et divertissements) de sorte qu’ils puissent vous parler de produits ou services pouvant vous intéresser. Nous partagerons uniquement vos informations avec ces tiers si vous y avez consenti. Si vous ne souhaitez pas utiliser vos données personnelles de cette manière ou changez généralement d’avis concernant la réception de toute forme de communications marketing, vous pouvez vous désabonner à tout moment en utilisant la fonctionnalité se désabonner dans la communication que vous recevez ou en modifiant votre profil en conséquence. Si vous choisissez de vous désabonner de nos publicités, nous conserverons un dossier de vos préférences afin de ne pas vous déranger avec des publicités non sollicitées à l’avenir.\n" +
      "\n" +
      "       . Si une quelconque partie de notre entreprise décide de constituer une entreprise commune, d'acheter une autre entreprise ou d'être vendue à une autre entité commerciale ou de fusionner avec celle-ci, vos informations peuvent être divulguées ou transférées à la société cible, ou aux nouveaux partenaires ou propriétaires commerciaux ou à leurs agents et conseillers. Dans ces circonstances, nous informerons toujours les entités en question que celles-ci doivent uniquement utiliser vos données personnelles pour les finalités énoncées dans cette Politique de Confidentialité.\n" +
      "\n" +
      "       . Tout organisme d’application de la loi ou réglementaire, agence gouvernementale ou autre tiers lorsque nous considérons que la divulgation est nécessaire (i) en vertu de la loi ou réglementation applicable (i) afin d’exercer, établir ou défendre nos droits, ou (iii) afin de protéger vos intérêts vitaux ou ceux de toute autre personne.\n" +
      "\n" +
      "       . Toute autre personne à condition que vous ayez consenti à la divulgation\n" +
      "\n" +
      "Nous ne vendrons, distribuerons, ni louerons vos données personnelles sauf si nous avons votre autorisation ou si nous sommes tenus de le faire en vertu de la loi.\n" +
      "\n" +
      "   . Base légale du traitement des données personnelles\n" +
      "\n" +
      "Notre base légale de collecte et d’utilisation de vos données personnelles comme susmentionnée dépendra du contexte spécifique dans lequel nous les collectons.\n" +
      "La raison principale de la collecte et de l’utilisation de vos données personnelles est d’exécuter notre contrat avec vous (c’est-à-dire, s’assurer que vous puissiez recevoir votre Commande quand et où vous le souhaitez). Toutefois, nous utiliserons également vos données personnelles lorsque ceci est dans nos intérêts commerciaux légitimes (mais uniquement si nos intérêts ne sont pas annulés par vos intérêts de protection des données ou vos droits légaux et libertés fondamentaux). Dans certains cas, nous pouvons avoir l’obligation légale de collecter des données personnelles auprès de vous (ex. dans le cas de procédures en justice) ou nous pouvons devoir les traiter ou partager avec des tiers afin de « protéger vos intérêts vitaux » (il s’agit d’une formulation juridique signifiant sauver votre vie) ou ceux d’une autre personne (ex. si la vie d’une autre personne est en danger).\n" +
      "\n" +
      "Si vous avez des questions ou avez besoin d’obtenir davantage d’informations concernant la base légale selon laquelle nous collectons et utilisons vos données personnelles, contactez-nous en utilisant les coordonnées fournies dans la rubrique « Comment nous contacter » ci-dessous.\n" +
      "\n" +
      "   . Transferts internationaux des données\n" +
      "\n" +
      "Nous pouvons transférer vos données personnelles dans des pays autres que le pays dans lequel vous résidez. Les serveurs du site web de SHISH sont principalement situés en  France. les sociétés de notre groupe et nos prestataires de services tiers et partenaires exercent leurs activités en FRANCE,  Ce qui signifie que lorsque nous collectons vos données personnelles nous pouvons les traiter dans un quelconque de ces pays.\n" +
      "\n" +
      "Alors que ces pays peuvent avoir des lois sur la protection des données différentes des lois de votre pays, vous pouvez être rassuré,  SHISH veille à mettre en œuvre des garanties appropriées afin de protéger vos données personnelles dans ces pays conformément à cette Politique de Confidentialité. Certaines des garanties seront basées notamment, le cas échéant, sur l’utilisation des clauses contractuelles types approuvées par la Commission européenne avec nos fournisseurs, les accords de transfert au sein du groupe (de sorte que nous puissions transférer en toute sécurité vos données entre les sociétés du groupe SHISH dans le monde entier) et la conclusion de contrats avec des sociétés certifiées.\n" +
      "   . Sécurité\n" +
      "\n" +
      "Nous accordons une grande importance à la conservation sure et sécurisée de vos données personnelles. Nous avons donc mis en place des mesures techniques et organisationnelles appropriées/la technologie standard de l’industrie afin de les protéger d’un accès non autorisé et d’un traitement illégal, d’une (e) perte, destruction ou endommagement accidentel(le).\n" +
      "Les mesures de sécurité que nous utilisons visent à fournir un niveau de sécurité approprié au risque du traitement de vos données personnelles. Lorsque vous avez choisi un mot de passe vous permettant d’accéder à certaines parties des Services, vous êtes responsable de garder ce mot de passe confidentiel. Nous vous conseillons de ne partager votre mot de passe avec personne et d’utiliser un mot de passe unique pour nos Services. Nous ne serons pas responsables d’une quelconque transaction non autorisée réalisée en utilisant vos nom et mot de passe. Si vous avez l’impression que vos données à caractère personnel ne sont pas protégées correctement ou si vous avez des indications d’abus, veuillez prendre contact avec nous : hello@shish.fr\n" +
      "\n" +
      "   . Conservation des données \n" +
      "\n" +
      "SHISH  conservera vos données personnelles lorsque nous avons une nécessité commerciale de le faire (par exemple, tandis que vous détenez un compte avec nous ou afin de nous permettre de respecter nos obligations légales, fiscales ou comptables.\n" +
      "Si vous vous opposez au traitement de certaines catégories de vos données personnelles (y compris concernant la réception de communications marketing de notre part), nous conserverons une trace de votre opposition au traitement de vos informations de sorte que nous puissions continuer à respecter votre volonté.\n" +
      "Nous détruirons ou rendrons totalement anonymes vos données personnelles lorsque nous n’aurons plus besoin de les traiter pour nos besoins commerciaux légitimes en cours ou pour tout motif. Si cela n’est pas possible (par exemple, du fait que vos données personnelles sont stockées dans des archives de sauvegarde), alors nous les stockerons en toute sécurité et les isolerons de tout autre traitement jusqu’à ce qu’il soit possible de les supprimer.\n" +
      "\n" +
      "   . Vos droits de protection des données\n" +
      "\n" +
      "SHISH  respecte vos droits de protection de votre vie privée et de protection des données. Se trouve ci-après un résumé de vos droits concernant vos informations personnelles traitées par SHISH\n" +
      "\n" +
      "       ◦ SHISH vous fournit les outils permettant d’accéder à, de consulter ou d’actualiser vos données personnelles à tout moment. Si vous souhaitez demander la suppression de vos données personnelles, vous pouvez le faire en nous contactant à l’aide des coordonnées fournies dans la rubrique « Comment nous contacter » ci-après.\n" +
      "       ◦ Vous pouvez vous opposer au traitement de vos données personnelles, nous demander de limiter le traitement de vos données personnelles ou demander à ce qu’elles soient transférées à un tiers. De même, vous pouvez exercer ces droits en nous contactant à l’aide des coordonnées fournies dans la rubrique « Comment nous contacter » ci-après.\n" +
      "       ◦ Vous pouvez décider, à tout moment, de ne plus recevoir les communications marketing que nous vous envoyons. Vous pouvez exercer ce droit en utilisant la fonctionnalité se désabonner concernant la communication que vous recevez ou en modifiant votre profil en conséquence.\n" +
      "       ◦ De même, si nous collectons et traitons vos données personnelles sur la base de votre consentement, vous pouvez retirer un tel consentement à tout moment. Le retrait de votre consentement n’affectera pas la légalité de tout traitement que nous avons effectuée avant votre retrait ni n’affectera le traitement de vos données personnelles effectué sur la base de motifs de traitement licites autres que votre consentement.\n" +
      "       ◦ Vous pouvez vous plaindre auprès de l’autorité de contrôle de protection des données concernant la collecte et l’utilisation de vos données personnelles.\n" +
      "Nous répondons à toutes les demandes que nous recevons de personnes souhaitant exercer leurs droits de protection des données conformément au droit applicable en matière de protection des données.\n" +
      "\n" +
      "   . Liens vers les sites tiers\n" +
      "\n" +
      "Notre site peut, occasionnellement, contenir des liens vers et depuis les sites web de nos réseaux partenaires, publicitaires et sociétés affiliées ou vers de nombreux sites web pouvant offrir des informations utiles à nos visiteurs.\n" +
      "\n" +
      "Nous vous fournissons ces liens uniquement à titre de commodité et l’inclusion d’un quelconque lien ne sous-entend pas l'adhésion aux pratiques du site web en question par SHISH Si vous suivez un lien vers un quelconque de ces sites web, sachez que ceux-ci ont leurs propres politiques de confidentialité et que nous n’acceptons aucune responsabilité pour ces politiques ou ces sites web liés. Consultez ces politiques avant de soumettre une quelconque donnée personnelle sur ces sites web.\n" +
      "\n" +
      "   . Mises à jour de cette Politique de Confidentialité\n" +
      "\n" +
      "Nous pouvons mettre à jour, occasionnellement, cette Politique de Confidentialité en réponse aux modifications légales, techniques ou commerciales. Lorsque nous mettons à jour notre Politique de Confidentialité, nous prendrons les mesures appropriées pour vous en informer, selon l’importance des modifications apportées. Nous obtiendrons votre consentement à toute modification importante de la Politique de Confidentialité si et lorsque le droit applicable en matière de protection des données l’exige. Nous vous encourageons à consulter régulièrement cette page afin de voir les dernières informations sur nos pratiques de confidentialité.\n" +
      "\n" +
      "   . Comment nous contacter?\n" +
      "\n" +
      "Si vous avez des questions ou des préoccupations concernant cette Politique de Confidentialité et les Pratiques de SHISH en matière de confidentialité, veuillez contacter notre service.\n" +
      "\n" +
      "Responsable de la Protection des Données:\n" +
      "Le responsable du traitement de vos données personnelles est l’entité SHISH en France.\n" +
      "\n\n";
}
