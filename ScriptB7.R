install.packages("PairedData") #Paquet PairedData necesari per tractar amb mostres aparellades
B7info <- read.table("clipboard", header = FALSE, dec = ",") #Copiem Les dades que tenim guardades en un excel

#Les 50 primeres dades s�n de C i les 50 segones s�n de Python
Ct =  B7info$V3[1:50]
Pt =  B7info$V3[51:100]

n = 50

#Comprovem la normalitat de la variable difer�ncia 
D = Pt - Ct
qqnorm(D)
qqline(D)

#Com que no es compleix la premisa de normalitat treiem logaritmes 
D = log(Pt/Ct)
qqnorm(D) #Ara s� que es compleixen les premises de normalitat 
qqline(D)

#C�lcul de l'estad�stic T. D~N i les mostes s�n aparellades
#La nostra hip�tesi nula �s que el C triga el mateix que Pyton (D = 0)
SD = sd(D)
T = mean(D)/(SD/sqrt(n)) #Segueix una distribuci� t-stduent amb 49 graus de llibertat

#C�lcul del punt cr�tic i p-valor
pCrit = qt(0.95, n - 1) #Punt cr�tic
pValor = 1 - pt(T, n - 1) #p-valor

#C�lcul de l'Interval de conifan�a del 95% de la variable difer�ncia
IC95 = c(mean(D) - qt(0.975, n - 1)*(SD/(sqrt(n))),mean(D) + qt(0.975, n - 1)*(SD/(sqrt(n)))) 

#c�lcul de l'interval de confian�a del 99.9% de la variable difer�ncia
IC99 = c(mean(D) - qt(0.9995, n - 1)*(SD/(sqrt(n))),mean(D) + qt(0.9995, n - 1)*(SD/(sqrt(n)))) 

#t.test
t.test(D)

#Tots els gr�fics
Cl <- log(Ct) #Traiem logaritmes per poder fer els plots
Pl <- log(Pt)
p <- PairedData::paired(Cl, Pl)
PairedData::plot(p, type = 'BA')
PairedData::plot(p, type = 'correlation')
PairedData::plot(p, type = 'McNeil')
PairedData::plot(p, type = 'profile')
qqnorm(D)
qqline(D)


D = log(Pt/Ct)
plot(Cl, Pl)
stripchart(D)


#Analisis B6
Z = B7info$V4[1:50]

#Traiem les mitjanes del temps en C (variable Y) i la mida del vector (Variable Z)
Y = mean(Pt)
X = mean(Z)

S2x = var(Z)
S2y = var(Pt)
Sx = sqrt(S2x)
Sy = sqrt(S2y)
Sxy = cov(Pt, Z)
rxy = cor(Pt, Z)

b1 = Sxy/S2x
b0 = Y - b1*X
S2 = ((n - 1)*(S2y - b1*Sxy))/(n - 2)
S2b1 = S2/((n - 1)*S2x)
S2b0 = S2*(1/n + (X^2/((n - 1)*S2x)))

#Prova de hip�tesi per veure si la relaci� pot ser una recta horizontal o realment �s creixent
#Ho = b1 = 0
#H1 = b1 > 0
Tb1 = b1/(sqrt(S2b1)) #~t-student amb 48 graus de llibertat
pCritb1 = qt(0.95, n - 2)
pValb1 = 1 - pt(Tb1, n - 2)

#Interval de confian�a del 95% per B1
IC95B1 = c(b1 - qt(0.975, n - 2)*sqrt(S2b1), b1 + qt(0.975, n - 2)*sqrt(S2b1)) 

#Interval de confian�a del 95% per B0
IC95B0 = c(b0 - qt(0.975, n - 2)*sqrt(S2b0), b0 + qt(0.975, n - 2)*sqrt(S2b0))  


lm(Pt ~ Z)
plot(Pt, Z)
D = Pt - Ct
D = log(Pt/Ct)
plot(D, Z)
plot(1:50, rstandard(lm(Pt~Z)), type = "b")
abline(0, 0)