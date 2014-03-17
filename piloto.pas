program Piloto;
/* declarações de variáveis e constantes globais */ 
var cont, total: integer ;
Nota1, Nota2, Media_das_medias, med: real;
/* Inicio do Programa */
begin
	media_das_medias := 0;
	writeln("******** ENTRADA DE DADOS ***************"); writeln("Digite o total de alunos");
	read(total);
	for cont=1 to total do
	begin
		writeln("Digite os valores da primeira nota do aluno ", cont); read(Nota1);
		writeln("Digite os valores da segunda nota do aluno ", cont); read(Nota2);
		med := (Nota1+Nota2)/2.0;
		media_das_medias := media_das_medias + med; write("Media = ",med);
	end;
	write("Media Geral = ",Media_das_medias/total);
end.