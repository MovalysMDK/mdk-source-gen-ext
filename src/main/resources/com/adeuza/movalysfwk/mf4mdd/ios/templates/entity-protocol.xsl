<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/constants.xsl"/>

<xsl:template match="class">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.h</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-protocol-imports"/>

/**
 * @brief Enum of properties of <xsl:value-of select="name"/> entity
 */
extern const struct <xsl:value-of select="name"/>Properties_Struct
<xsl:text>{&#13;</xsl:text>
	<xsl:text>	__unsafe_unretained NSString *EntityName;	/*!&lt; Entity name */&#13;</xsl:text>
<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(ancestor::association)]">
    <xsl:text>	__unsafe_unretained NSString *</xsl:text><xsl:value-of select="@name"/><xsl:text>;	/*!&lt; property </xsl:text><xsl:value-of select="@name"/><xsl:text> */&#13;</xsl:text>
</xsl:for-each>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-structproperties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
} <xsl:value-of select="name"/>Properties;
 
/**
 * @brief <xsl:value-of select="name"/><xsl:text> entity&#13;</xsl:text>
 * @details <xsl:value-of select="/class/documentation"/>
 */
<xsl:text>@interface </xsl:text><xsl:value-of select="name"/><xsl:text> : NSManagedObject</xsl:text>
<xsl:if test="stereotypes/stereotype[@name = 'Mm_AddressLocation']">
	<xsl:text>&lt;MFPositionVoProtocol&gt;</xsl:text>
</xsl:if>
<xsl:if test="stereotypes/stereotype[@name = 'Mm_Photo']">
	<xsl:text>&lt;MFPhotoVoProtocol&gt;</xsl:text>
</xsl:if>
<xsl:text>&#13;&#13;</xsl:text>

<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(ancestor::association)]">
	<xsl:text>/**&#13;</xsl:text>
	<xsl:text> * @brief </xsl:text><xsl:value-of select="@name"/><xsl:text> property (</xsl:text>
	<xsl:if test="name()= 'attribute'">
		<xsl:text>mandatory=</xsl:text>
		<xsl:value-of select="@nullable = 'false'"/>
		<xsl:if test="@unique and @unique='true'">
			<xsl:text> unique=</xsl:text>
			<xsl:value-of select="@unique and @unique='true'"/>
		</xsl:if>
		<xsl:text> transient=</xsl:text>
		<xsl:value-of select="@transient"/>
	</xsl:if>
	<xsl:if test="name()= 'association'">
		 <!-- type de relation -->
		<xsl:if test="@type = 'many-to-one'">
				<xsl:text>Relation ManyToOne</xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-many'">
			<xsl:text>Relation OneToMany</xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-one'">
			<xsl:text>Relation OneToOne</xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'many-to-many'">
			<xsl:text>Relation ManyToMany</xsl:text>
		</xsl:if>
		<!-- objet cible -->
		<xsl:text> targetEntity=</xsl:text>
		<xsl:value-of select="interface/name"/>
		<!-- obligatoire -->
		<xsl:if test="@type = 'many-to-one' or @type = 'one-to-one'">
			<xsl:text> mandatory=</xsl:text>
			<xsl:value-of select="@optional != 'true'"/>
		</xsl:if>
		<!-- proprietaire de la relation -->
		<!-- 
		<xsl:text> relationOwner=</xsl:text>
		<xsl:value-of select="@relation-owner"/>
		 -->
		<!-- transient -->
		<xsl:text> transient=</xsl:text>
		<xsl:value-of select="@transient"/>
	</xsl:if>
	<xsl:text>)&#13;</xsl:text>
	<xsl:if test="documentation/doc-attribute | documentation/doc-getter | documentation/doc-setter">
		<xsl:text>  @details</xsl:text>
		<xsl:if test="documentation/doc-attribute">
			<xsl:text>  @b Property: </xsl:text><xsl:value-of select="documentation/doc-attribute"/><xsl:text>&#13;</xsl:text>
			<xsl:if test="documentation/doc-getter | documentation/doc-getter">
				<xsl:text>&#13;</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="documentation/doc-getter">
			<xsl:text>  @b Getter: </xsl:text><xsl:value-of select="documentation/doc-getter"/><xsl:text>&#13;</xsl:text>
			<xsl:if test="documentation/doc-setter">
				<xsl:text>&#13;</xsl:text>
			</xsl:if>			
		</xsl:if>
		<xsl:if test="documentation/doc-setter">
			<xsl:text>  @b Setter: </xsl:text><xsl:value-of select="documentation/doc-setter"/><xsl:text>&#13;</xsl:text>
		</xsl:if>
	</xsl:if>
	<xsl:text> */&#13;</xsl:text>
	<xsl:text>@property (nonatomic</xsl:text>
	<xsl:if test="not(@enum) or @enum = 'false'">
		<xsl:text>, retain</xsl:text>
	</xsl:if>
	<xsl:text>) </xsl:text>

	<xsl:value-of select="@type-short-name"/>
	<xsl:text> </xsl:text>
	<xsl:if test="not(@enum) or @enum = 'false'">
		<xsl:text>*</xsl:text>
	</xsl:if>
	<xsl:value-of select="@name"/><xsl:text>;&#13;&#13;</xsl:text>

</xsl:for-each>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

/**
 * @category <xsl:value-of select="name"/>(CoreDataGeneratedAccessors) 
 * @abstract Category CoreDataGeneratedAccessors on <xsl:value-of select="name"/>
 */
@interface <xsl:value-of select="name"/> (CoreDataGeneratedAccessors)
<xsl:for-each select="association[@type='one-to-many' or @type='many-to-many']">
/**
 * @brief Add a <xsl:value-of select="interface/name"/> to the <xsl:value-of select="@name"/> list
 * @param value <xsl:value-of select="interface/name"/> object to add  
 */
- (void)add<xsl:value-of select="@name-capitalized"/>Object:(<xsl:value-of select="interface/name"/>*)value;

/**
 * @brief Remove a <xsl:value-of select="interface/name"/> from the <xsl:value-of select="@name"/> list
 * @param value <xsl:value-of select="interface/name"/> object to remove 
 */
- (void)remove<xsl:value-of select="@name-capitalized"/>Object:(<xsl:value-of select="interface/name"/>*)value;

/**
 * @brief Add a list of <xsl:value-of select="interface/name"/> to the <xsl:value-of select="@name"/> list
 * @param values <xsl:value-of select="interface/name"/> list to add  
 */
- (void)add<xsl:value-of select="@name-capitalized"/>:(NSSet *)values;

/**
 * @brief Remove a list of <xsl:value-of select="interface/name"/> from the <xsl:value-of select="@name"/> list
 * @param values <xsl:value-of select="interface/name"/> list to remove  
 */
- (void)remove<xsl:value-of select="@name-capitalized"/>:(NSSet *)values;
</xsl:for-each>
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-coredata-genaccessors</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>
@end

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-part</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
	<objc-import class="Foundation" header="Foundation/Foundation.h" scope="global"/>
	<objc-import class="CoreData" header="CoreData/CoreData.h" scope="global"/>
</xsl:template>

</xsl:stylesheet>