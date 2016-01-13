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
<xsl:template match="external-list" mode="generate-parameter">
	<xsl:text>, final Collection&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>&gt; p_list</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>s</xsl:text>
	<xsl:value-of select="position()"/>
</xsl:template>

<xsl:template match="external-list" mode="generate-view-model-creation">
	<xsl:param name="viewmodel-implementation"/>

	<xsl:variable name="var-list">
		<xsl:text>list</xsl:text>
		<xsl:value-of select="./viewmodel/implements/interface/@name"/>
		<xsl:text>s</xsl:text>
		<xsl:value-of select="position()"/>
	</xsl:variable>

	<xsl:text>ListViewModel&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text> = r_oMasterViewModel.</xsl:text>
	<xsl:value-of select="./viewmodel/list-accessor-get-name"/>
	<xsl:text>();&#13;</xsl:text>

	<xsl:text>if (</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text> == null) {&#13;</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text> = new ListViewModelImpl&lt;</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>&gt;();&#13;</xsl:text>
	<xsl:text>r_oMasterViewModel.</xsl:text>
	<xsl:value-of select="./viewmodel/list-accessor-set-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text>);&#13;}&#13;else {&#13;</xsl:text>
	<xsl:value-of select="$var-list"/>
	<xsl:text>.Clear();&#13;}&#13;</xsl:text>

	<xsl:text>if (p_list</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>s</xsl:text>
	<xsl:value-of select="position()"/>
	<xsl:text> != null) {&#13;</xsl:text>
	<xsl:text>foreach (</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text> o</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text> in p_list</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>s</xsl:text>
	<xsl:value-of select="position()"/>
	<xsl:text>) {&#13;</xsl:text>

	<xsl:value-of select="$var-list"/>
	<xsl:text>.Add(this.CreateOrUpdate</xsl:text>
	<xsl:value-of select="./viewmodel/implements/interface/@name"/>
	<xsl:text>(o</xsl:text>
	<xsl:value-of select="./viewmodel/entity-to-update/name"/>
	<xsl:text>));&#13;</xsl:text>

	<xsl:text>}&#13;}&#13;&#13;</xsl:text>
</xsl:template>

	<xsl:template match="external-list" mode="generate-parameter-loader">
		<!-- A revoir lorsque DataLoader alimenté -->
<!-- 		<xsl:text>, p_oDataLoader.GetList</xsl:text>
		<xsl:value-of select="./viewmodel/entity-to-update/name"/>
		<xsl:text>()</xsl:text>
 -->
	</xsl:template>

</xsl:stylesheet>