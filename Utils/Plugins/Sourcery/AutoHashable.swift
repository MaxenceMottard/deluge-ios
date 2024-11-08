import Foundation

extension SourceryBuildToolPlugin {
    var AutoHashable: Template {
        .init(
            name: "AutoHashable",
            content: """
            // swiftlint:disable all

            import Foundation

            {% macro combineVariableHashes variables %}
            {% for variable in variables where variable.readAccess != "private" and variable.readAccess != "fileprivate" %}
            {% if not variable.annotations.skipHashing %}
                    {% if variable.isStatic %}type(of: self).{% endif %}{{ variable.name }}.hash(into: &hasher)
            {% endif %}
            {% endfor %}
            {% endmacro %}

            // MARK: - AutoHashable for classes, protocols, structs
            {% for type in types.types|!enum where type.implements.AutoHashable or type|annotated:"AutoHashable" %}
            // MARK: - {{ type.name }} AutoHashable
            extension {{ type.name }}{% if not type.kind == "protocol" and not type.based.NSObject %}: Hashable{% endif %} {
                {{ type.accessLevel }}{% if type.based.NSObject or type.supertype.implements.AutoHashable or type.supertype|annotated:"AutoHashable" or type.supertype.based.Hashable %} override{% endif %} func hash(into hasher: inout Hasher) {
                    {% if type.based.NSObject or type.supertype.implements.AutoHashable or type.supertype|annotated:"AutoHashable" or type.supertype.based.Hashable %}
                    super.hash(into: hasher)
                    {% endif %}
                    {% if not type.kind == "protocol" %}
                    {% call combineVariableHashes type.storedVariables %}
                    {% else %}
                    {% call combineVariableHashes type.allVariables %}
                    {% endif %}
                }
            }
            {% endfor %}

            // MARK: - AutoHashable for Enums
            {% for type in types.enums where type.implements.AutoHashable or type|annotated:"AutoHashable" %}

            // MARK: - {{ type.name }} AutoHashable
            extension {{ type.name }}: Hashable {
                {{ type.accessLevel }} func hash(into hasher: inout Hasher) {
                    switch self {
                    {% for case in type.cases %}
                    {% if case.hasAssociatedValue %}
                    {% if case.associatedValues.count == 1 %}
                    case let .{{ case.name }}(data):
                    {% else %}
                    {% map case.associatedValues into associatedValues using associated %}{{ associated.externalName }}{% endmap %}
                    case let .{{ case.name }}({{ associatedValues|join: ", " }}):
                    {% endif %}
                    {% else %}
                    case .{{ case.name }}:
                    {% endif %}
                        {{ forloop.counter }}.hash(into: &hasher)
                        {% if type.computedVariables.count > 0 %}
                        {% for variable in type.computedVariables %}
                        {% if not variable.annotations.skipHashing %}{{ variable.name }}.hash(into: &hasher)
                        {% endif %}
                        {% endfor %}
                        {% endif %}
                        {% if case.hasAssociatedValue %}
                        {% if case.associatedValues.count == 1 %}
                        data.hash(into: &hasher)
                        {% else %}
                        {% for associated in case.associatedValues %}{{ associated.externalName }}.hash(into: &hasher)
                        {% endfor %}
                        {% endif %}
                        {% endif %}
                        {% endfor %}
                    }
                }
            }
            {% endfor %}
            // swiftlint:enable all
            """
        )
    }
}
