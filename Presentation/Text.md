Nix Presentation:

1. Nix

	So what is nix ? 

		( new slide )

	Nix encompasses a domain-specific, purely functional, and 	lazy programming language, a package manager, and serves 	as the foundation for NixOS, a Linux distribution.

		
		(new slide)

	Domain-specific: Nix is designed specifically for package 		management and system configuration, not as a general-		purpose language.

	Purely functional: Nix lacks sequential execution; 			dependencies between operations are solely data-dependent.

	Every Nix expression evaluates to a value, resulting in a single 	data structure without executing sequential operations.
	
	Lazy evaluation: Expressions are evaluated only when their 	results are needed.
	
		(new slide )

	For example, the built-in function throw halts evaluation. In the 	following expression, evaluation succeeds because the thrown 	exception is never accessed:

		( new slide )

	Traditional package managers like dpkg and rpm modify the 	global system state. For instance, installing foo-1.0 to /usr/bin/	foo prevents simultaneous installation of foo-1.1 without 		altering installation paths or binary names, which can disrupt 	dependent applications.
	
	While solutions like Debian's alternatives system exist, 			managing multiple versions remains complex.


	Nix operates independently of the global system state, 			utilizing the Nix store (typically located at /nix/store) to 		manage packages.
	In Nix, a "derivation" defines how to build a package, 			encompassing its dependencies and build instructions.


		( new slide )
	
	Derivations are stored in the Nix store with paths like /nix/		store/«hash-name».

	For example, a Bash derivation might reside at /nix/store/		…/, 	containing bin/bash.
	
	This approach eliminates global binaries like /bin/bash, 		instead providing self-contained build outputs in the store.
	Nix adjusts the PATH to make these binaries accessible.
	The Nix store maintains all packages, with different versions in 	separate locations, and its contents are immutable.

	
		( new slide  ) 
	
	NixOS is a Linux distribution built on the Nix package 			manager. It uses declarative Nix configuration files to define 	the entire system state and supports atomic upgrades and 		rollbacks.
	
	In NixOS, all components—including the kernel, packages, and 	configuration files—are built from Nix expressions, ensuring 	consistency and reproducibility.



2. Benefits 

		(new slide )
	
	Reproducible Environments:
	Nix enables deterministic builds through declarative 			specifications, ensuring that environments can be replicated 	precisely across different systems.
	Dependency Management:
	By isolating packages and their dependencies, Nix facilitates 	seamless collaboration on projects with complex dependency 	trees, reducing conflicts and inconsistencies.
	Nixpkgs
	The Nix Packages collection (nixpkgs) offers a vast repository 	of software, including tools like GitLab, Git, DBeaver, and 		various programming languages such as Java, C, and Python.

3. Flakes

		( new slide )
	
	Introduced around late 2021, flakes are an experimental 		feature in Nix that aim to standardize project structures and 	simplify sharing and maintenance.

		(new slides for each point with examples )

	A flake typically includes:
	
	description: A string describing the flake
	
	inputs: An attribute set of the flake's dependencies.
	
	outputs: A function that takes the realized inputs and returns 	an attribute set of Nix assets like packages or NixOS modules.
	
	nixConfig: An attribute set reflecting values given to nix.conf, 	allowing for flake-specific configurations.

4. Nix and Docker

		(new slide again with informative icons to text)

	Complementary Roles: 
	Docker provides a reproducible 	runtime environment, while 		Nix ensures a reproducible build environment. 

	Integrating Nix with Docker can eliminate issues where 			software behaves differently across environments by 			ensuring consistent build processes.

	Advantages of Integration:
	Using Nix to manage dependencies within Docker images 		ensures that only specified dependencies are included, 		preventing the inclusion of untrusted sources and accidental 	dependencies. 
	This approach enhances security and compliance with 			licensing agreements.
	

5. Conclusion

Personally, since I used it extensively during my internship, I am kinda split in opinion about Nix. On one side it can be extremely helpful and amazing, like the simplicity of installing software with the nix packages and the possibility to configure your whole work environment in a single file and share it company wide etc.
However, it can also be extremely stressing, as example once, when I worked on a project with nom, nom worked well, but the nix implementation did not fetch dependencies, but aborted, so it sometimes takes huge detective work how and why something happened and even more to patch it. ( will explain further in detail )

