import Foundation

extension SourceryBuildToolPlugin {
    var AutoEquatable: Template {
        .init(
            name: "AutoEquatable",
            content: """
            // swiftlint:disable all

            import Foundation
            {% for import in argument.Library %}
            import {{ import }}
            {% endfor %}

            fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
                switch (lhs, rhs) {
                case let (lValue?, rValue?):
                    return compare(lValue, rValue)
                case (nil, nil):
                    return true
                default:
                    return false
                }
            }

            fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
                guard lhs.count == rhs.count else { return false }
                for (idx, lhsItem) in lhs.enumerated() {
                    guard compare(lhsItem, rhs[idx]) else { return false }
                }

                return true
            }

            {% macro compareVariables variables %}
                {% for variable in variables where variable.readAccess != "private" and variable.readAccess != "fileprivate" %}{% if not variable.annotations.skipEquality %}guard {% if not variable.isOptional %}{% if not variable.annotations.arrayEquality %}lhs.{{ variable.name }} == rhs.{{ variable.name }}{% else %}compareArrays(lhs: lhs.{{ variable.name }}, rhs: rhs.{{ variable.name }}, compare: ==){% endif %}{% else %}compareOptionals(lhs: lhs.{{ variable.name }}, rhs: rhs.{{ variable.name }}, compare: ==){% endif %} else { return false }{% endif %}
                {% endfor %}
            {% endmacro %}

            // MARK: - AutoEquatable for classes, protocols, structs
            {% for type in types.types|!enum where type.implements.AutoEquatable or type|annotated:"AutoEquatable" %}
            // MARK: - {{ type.name }} AutoEquatable
            {% if not type.kind == "protocol" and not type.based.NSObject %}extension {{ type.name }}: Equatable {}{% endif %}
            {% if type.supertype.based.Equatable or type.supertype.implements.AutoEquatable or type.supertype|annotated:"AutoEquatable" %}THIS WONT COMPILE, WE DONT SUPPORT INHERITANCE for AutoEquatable{% endif %}
            {{ type.accessLevel }} func == (lhs: {{ type.name }}, rhs: {{ type.name }}) -> Bool {
                {% if not type.kind == "protocol" %}
                {% call compareVariables type.storedVariables %}
                {% else %}
                {% call compareVariables type.allVariables %}
                {% endif %}
                return true
            }
            {% endfor %}

            // MARK: - AutoEquatable for Enums
            {% for type in types.enums where type.implements.AutoEquatable or type|annotated:"AutoEquatable" %}
            // MARK: - {{ type.name }} AutoEquatable
            extension {{ type.name }}: Equatable {}
            {{ type.accessLevel }} func == (lhs: {{ type.name }}, rhs: {{ type.name }}) -> Bool {
                switch (lhs, rhs) {
                {% for case in type.cases %}
                {% if case.hasAssociatedValue %}
                {% if case.associatedValues.count == 1 %}
                case let (.{{ case.name }}(lhs), .{{ case.name }}(rhs)):
                {% else %}
                {% map case.associatedValues into lhsValues using associated %}lhs{{ associated.externalName|upperFirstLetter }}{% endmap %}
                {% map case.associatedValues into rhsValues using associated %}rhs{{ associated.externalName|upperFirstLetter }}{% endmap %}
                case let (.{{ case.name }}({{ lhsValues|join: ", " }}), .{{ case.name }}({{ rhsValues|join: ", " }})):
                {% endif %}
                {% else %}
                case (.{{ case.name }}, .{{ case.name }}):
                {% endif %}
                    {% if not case.hasAssociatedValue %}return true{% else %}
                    {% if case.associatedValues.count == 1 %}
                    return lhs == rhs
                    {% else %}
                    {% for associated in case.associatedValues %}if lhs{{ associated.externalName|upperFirstLetter }} != rhs{{ associated.externalName|upperFirstLetter }} { return false }
                    {% endfor %}return true
                    {% endif %}
                    {% endif %}
                {% endfor %}
                {{ 'default: return false' if type.cases.count > 1 }}
                }
            }
            {% endfor %}
            // swiftlint:enable all
            """
        )
    }
}
