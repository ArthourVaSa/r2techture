.PHONY: test run run-yaml clean coverage

# Ejecutar todos los tests
test:
	dart test --coverage=coverage
	format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib
	genhtml coverage/lcov.info -o coverage/html

# Ejecutar la librería principal (r2techture CLI)
run:
	dart run bin/r2techture.dart

# Ejecutar el CLI con un archivo YAML específico
run-yaml:
	dart run bin/r2techture.dart create mi_app.yaml

# Limpiar cobertura (opcional)
clean:
	rm -rf coverage

# Generar DI
assemble:
	dart run build_runner build --delete-conflicting-outputs
