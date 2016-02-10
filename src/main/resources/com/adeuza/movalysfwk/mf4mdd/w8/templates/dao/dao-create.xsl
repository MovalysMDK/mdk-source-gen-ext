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

<xsl:template match="dao-interface" mode="dao-create-region">

	<xsl:text>#region CREATE</xsl:text>
	
	/// &lt;summary&gt;
	/// Executes a "create table if not exists" on the database. It also
	/// creates any specified indexes on the columns of the table. It uses
	/// a schema automatically generated from the specified type. You can
	/// later access this schema by calling GetMapping.
	/// &lt;/summary&gt;
	/// &lt;param name="context"&gt;Context for the operation&lt;/param&gt;&#13;
	/// &lt;returns&gt;
	/// The number of entries added to the database schema.
	/// &lt;/returns&gt;
	int CreateTable<xsl:value-of select="./dao/class/name"/>(IMFContext context);

	/// &lt;summary&gt;
	/// Executes a "create table if not exists" on the database. It also
	/// creates any specified indexes on the columns of the table. It uses
	/// a schema automatically generated from the specified type. You can
	/// later access this schema by calling GetMapping.
	/// &lt;/summary&gt;
	/// &lt;param name="context"&gt;Context for the operation&lt;/param&gt;&#13;
	/// &lt;returns&gt;
	/// The number of entries added to the database schema.
	/// &lt;/returns&gt;
	Task&lt;int&gt; CreateTable<xsl:value-of select="./dao/class/name"/>Async(IMFContext context);

	<xsl:text>#endregion&#13;</xsl:text>

</xsl:template>


<xsl:template match="dao" mode="dao-create-region">

	<xsl:text>#region CREATE&#13;&#13;</xsl:text>
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public int CreateTable<xsl:value-of select="./class/name"/>(IMFContext p_oContext) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">CreateTable</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>return this.CreateTable(p_oContext);&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>		
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public async Task&lt;int&gt; CreateTable<xsl:value-of select="./class/name"/>Async(IMFContext p_oContext) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">CreateTableAsync</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>return await this.CreateTableAsync(p_oContext);&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	}
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>

</xsl:template>

</xsl:stylesheet>
