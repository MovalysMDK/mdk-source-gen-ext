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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
		
<!-- DTN - EN COURS DE TRAITEMENT -->

<xsl:template match="node()" mode="declare-protocol-imports">
	<xsl:apply-templates select="." mode="declare-imports"/>
	<xsl:text></xsl:text>
	<xsl:apply-templates select="." mode="declare-class"/>
</xsl:template>

<xsl:template match="node()" mode="declare-impl-imports">
	<xsl:apply-templates select="." mode="declare-imports"/>
</xsl:template>

<xsl:template match="node()" mode="declare-imports">
	<xsl:param name="useClass">false</xsl:param>
	<xsl:variable name="currentId" select="generate-id(.)"/>
	<xsl:variable name="ancestorId" select="generate-id(/node())"/>
	
	<xsl:variable name="imports">
		<objc-imports>
			<xsl:copy-of select="objc-imports/objc-import"/>
			<xsl:if test="$currentId != $ancestorId">
				<xsl:copy-of select="/node()/objc-imports/objc-import"/>
			</xsl:if>
			<xsl:apply-templates select="." mode="declare-extra-imports"/>
		</objc-imports>
	</xsl:variable>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'FRAMEWORK' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Frameworks&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'FRAMEWORK' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'ENUMERATION' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Enumeration headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'ENUMERATION' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'ENTITIES' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Entity headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'ENTITIES' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'FACTORIES' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Factory headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'FACTORIES' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'DAO' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Dao headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'DAO' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'VALIDATORS' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Validator headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'VALIDATORS' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>
	
	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'VIEWMODEL' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Viewmodel headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'VIEWMODEL' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'DATALOADER' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Dataloader headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'DATALOADER' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'CONTROLLER' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Controller headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'CONTROLLER' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>
	
	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'ACTION' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Action headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'ACTION' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>		

	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'UI' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// UI headers&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'UI' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>		
	
	<xsl:if test="count(exsl:node-set($imports)/objc-imports/objc-import[@category = 'OTHERS' and (not(@self) or @self != '$useClass')]) > 0">
	<xsl:text>// Others&#13;</xsl:text>
	<xsl:apply-templates select="exsl:node-set($imports)/objc-imports/objc-import[@category = 'OTHERS' and (not(@self) or @self != '$useClass')]" mode="write-import">
		<xsl:sort/>
	</xsl:apply-templates>
	</xsl:if>

</xsl:template>

<xsl:template match="node()" mode="declare-class">
	<xsl:variable name="currentId" select="generate-id(.)"/>
	<xsl:variable name="ancestorId" select="generate-id(/node())"/>
	<xsl:variable name="classes">
		<objc-classes>
			<xsl:copy-of select="objc-classes/objc-class"/>
			<xsl:apply-templates select="." mode="declare-extra-class"/>
		</objc-classes>
	</xsl:variable>

	<xsl:apply-templates select="exsl:node-set($classes)/objc-classes/objc-class" mode="write-class">
		<xsl:sort/>
	</xsl:apply-templates>

</xsl:template>

<xsl:template match="objc-import" mode="write-import">
	<xsl:variable name="currentImport" select="text()"/>
	<xsl:if test="count(preceding-sibling::objc-import[text()=$currentImport]) = 0">
		<xsl:text>using </xsl:text>
		<xsl:value-of select="@class"/>
		<xsl:text>;&#13;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="objc-class" mode="write-class">
	<xsl:variable name="currentImport" select="text()"/>
	<xsl:if test="count(preceding-sibling::objc-class[text()=$currentImport]) = 0">
		<xsl:if test="position() = 1">
			<xsl:text>@class </xsl:text>
		</xsl:if>
		<xsl:value-of select="."/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:text>;</xsl:text>
		</xsl:if>
	</xsl:if>
</xsl:template>

<!-- permet de créer une import C# à partir de n importe quel texte ou attribut -->
<xsl:template match="text()|@*" mode="import">
	<xsl:text>using "</xsl:text> 
	<xsl:value-of select="."/>
</xsl:template>

<!-- permet de créer une import C# à partir de n importe quel texte ou attribut -->
<xsl:template name="model-imports">
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.SQLite;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<!-- permet de créer les using C# pour les implémentations des modèles -->
<xsl:template name="model-impl-using">
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.SQLite;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<!-- permet de créer les using C# pour les interfaces des modèles -->
<xsl:template name="model-interface-using">
	<xsl:text>using mdk_common.Attributs;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.SQLite;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<!-- permet de créer les using C# pour les interfaces des factories des modèles -->
<xsl:template name="pojo-factory-interface-using">
	<xsl:text>using mdk_common.Attributs;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<!-- permet de créer les using C# pour les implémentations des factories des modèles -->
<xsl:template name="pojo-factory-using">
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<!-- permet de créer les using C# pour les cascades des modèles -->
<xsl:template name="model-cascade-using">
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<!-- permet de créer les using C# pour les enumerations des modèles -->
<xsl:template name="enumeration-using">
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<!-- permet de créer les using C# pour les modèles des vues -->
<xsl:template  name="viewmodel-imports">
	<xsl:text>using mdk_common;</xsl:text>
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Application.RunInits;</xsl:text>
	<xsl:text>using mdk_common.Attributs;</xsl:text>
	<xsl:text>using mdk_common.Context;</xsl:text>
	<xsl:text>using mdk_common.Controller;</xsl:text>
	<xsl:text>using mdk_common.MFAction;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.ViewModel;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Collections.ObjectModel;</xsl:text>
	<xsl:text>using System.IO;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
	<xsl:text>using System.Xml.Serialization;</xsl:text>
	<xsl:text>&#13;</xsl:text>
</xsl:template>

<xsl:template name="dao-imports">
	<xsl:text>using mdk_common;</xsl:text>
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Context;</xsl:text>
	<xsl:text>using mdk_common.Dao;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.SQLite;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
	<xsl:text>using System.Linq.Expressions;</xsl:text>
</xsl:template>

<xsl:template name="dao-interface-imports">
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Attributs;</xsl:text>
	<xsl:text>using mdk_common.Context;</xsl:text>
	<xsl:text>using mdk_common.Dao;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.SQLite;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<xsl:template match="dataloader-impl" mode="data-loader-imports">
	<xsl:text>using mdk_common;</xsl:text>
	<xsl:text>using mdk_common.Context;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.DataLoader;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<xsl:template match="dataloader-interface" mode="data-loader-imports">
	<xsl:text>using mdk_common;</xsl:text>
	<xsl:text>using mdk_common.Attributs;</xsl:text>
	<xsl:text>using mdk_common.Context;</xsl:text>
	<xsl:text>using mdk_common.DataLoader;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using System.Text;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="declare-protocol-imports" priority="-900">
	//No headers
</xsl:template>
	
	
</xsl:stylesheet>