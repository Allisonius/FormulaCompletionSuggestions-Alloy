open util/ordering [Time]

module AssistenciaHospitalar

sig Time{}

one sig Servidor{
	gerentes: some Medico,
	plataformaServidor: one Linux,
	suporte: one Suporte,
	pacientesCadastrados: set Paciente,
	medicos: set Medico
}

sig Paciente{
	data: one DataDeNascimento,
	nomePaciente: one Nome,
	sintomas: Sintoma -> Time,
	emailPaciente: one Email,
	loginPaciente: one Login,
	senhaPaciente: one Senha,
	sistemaPaciente: one SistemaCliente,
	statusPaciente: StatusCadastro one -> Time
}

sig Medico{
	pacientes: Paciente -> Time,
	senhaMedico: one Senha,
	nomeMedico: one Nome,
	emailMedico: one Email,
	loginMedico: one Login,
	statusMedico:  StatusCadastro one -> Time
}

sig SistemaCliente{
	internet: one StatusInternet,
	plataforma: one SistemaOperacional
}

one sig Suporte{
	statusDoSuporte: StatusAcionado one -> Time
}

abstract sig StatusAcionado{}

sig SuporteAcionado, SuporteNaoAcionado extends StatusAcionado{}

abstract sig StatusCadastro{}

sig Cadastrado, NaoCadastrado extends StatusCadastro{}

abstract sig StatusInternet{}

sig ComInternet, SemInternet extends StatusInternet{}

abstract sig SistemaOperacional{}

one	sig Linux extends SistemaOperacional{}

sig Senha{}

sig Login{}

sig Nome{}	

sig Email{}

sig DataDeNascimento{}

sig Sintoma{}