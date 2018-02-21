pragma solidity ^0.4.0;
contract jeu_loup_garou {
    
    uint public nombre_de_joueur;
    
    struct Joueurs
    {
    address addressparticipants;
    uint role;
    uint vote;
    //uint vote_contre;
    }
    Joueurs[] public liste_participants; // la liste s'initialise à 0
    
    modifier isowner(){
       if(msg.sender!=owner){throw;
       _;
       }
   }
    
    mapping(address => address) public vote_contre;
    
    function update(uint joueur) public {
        vote_contre[joueur] = 1;
    }
    
function initialisation_loup_garou()
{
    uint nmb_loup_garou;
    if (nombre_de_joueur<8 && nombre_de_joueur>18) throw;
    if (nombre_de_joueur>=12 && nombre_de_joueur<=18)
    {
        nmb_loup_garou=3;
    }
    else 
    {
     nmb_loup_garou=2;
    }
    
    uint indice = nombre_de_joueur;
    while(indice>0)
    {
        liste_participants[indice].role=0; //permet d'initialiser la liste à 0
        indice=indice-1;
    }
    
    uint loup;
    uint loup2;
    uint loup3;
    if (nmb_loup_garou == 2)
    {
    loup=uint(block.blockhash(block.number-1))%nombre_de_joueur; //il n'est pas possible de générer un nombre aléatoire, on se base sur le hash du dernier bloc généré, converti en entier et on ajoute modulo le nombre de participants
    loup2=uint(block.blockhash(block.number-1))* 2 % nombre_de_joueur;
    liste_participants[loup].role=1;
    liste_participants[loup2].role=1;
    }
    if (nmb_loup_garou == 3)
    {
    loup=uint(block.blockhash(block.number-1))%nombre_de_joueur; //il n'est pas possible de générer un nombre aléatoire, on se base sur le hash du dernier bloc généré, converti en entier et on ajoute modulo le nombre de participants
    loup2=uint(block.blockhash(block.number-1))* 2 % nombre_de_joueur;
    loup3=uint(block.blockhash(block.number-1))* 3 % nombre_de_joueur;
    liste_participants[loup].role=1;
    liste_participants[loup2].role=1;
    liste_participants[loup3].role=1;
    }
    
    
}
    
// le jeu est initialisé, on possède une liste avec le nombre de joueur,dans cette liste
//la ième position correspond au ième joueur. Si il est initialisé à 0 c'est un villageois, si il
//est initialisé à 1 c'est un loup garou
//la variable role peut également être égal à -1 si la personne est éliminé
    


    function vote_nuit(uint voteChoice)
    {
        uint indice = nombre_de_joueur;
        while (indice>0)
        {
            if (liste_participants[indice].role==1)
            {
               if(voteChoice > liste_participants.length) throw;
                liste_participants.push( Joueurs({
                    addressparticipants : msg.sender,
                    role : 1,
                    vote : voteChoice
                    //vote_contre: vote_contre,  
                    
                        })
                    );
                    update(voteChoice);
            }
            indice=indice -1;
        }
        //totaliser les votes et éliminer la personne (mettre -1 dans la liste quand la personne est éliminer)
    }
    
    function vote_jour(uint voteChoice)
    {
        uint indice = nombre_de_joueur;
        while (indice>0)
        {
            if (liste_participants[indice].role==0)
            {
                if(voteChoice > liste_participants.length) throw;
                liste_participants.push( Joueurs({
                    addressparticipants : msg.sender,
                    vote : voteChoice,
                    //vote_contre: vote_contre,
                    role : 0
                    
                        })
                    );
                    update(voteChoice);
            }
            if (liste_participants[indice].role==1)
            {
                if(voteChoice > liste_participants.length) throw;
                liste_participants.push( Joueurs({
                    addressparticipants : msg.sender,
                    vote : voteChoice,
                    //vote_contre: vote_contre, 
                    role : 1
                    
                        })
                    );
                    update(voteChoice);
            }
            indice=indice -1;
        }
        //totaliser les votes et éliminer la personne (mettre -1 dans la liste quand la personne est éliminer)
    }
    
    
      function kill() isowner(){
           delete isowner;
           selfdestruct(msg.sender);
       }
}