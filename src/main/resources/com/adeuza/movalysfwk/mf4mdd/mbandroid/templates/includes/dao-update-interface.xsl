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

<xsl:template match="dao-interface" mode="update">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Met à jour, en base de données, l'entité <xsl:value-of select="interface/name"/> passée en paramètre.
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités	 
	 * @param p_oDaoSession dao session
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void update<xsl:value-of select="$interface/name"/>( <xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;
</xsl:text>
	
</xsl:template>

</xsl:stylesheet>
