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

<xsl:template match="dao-interface" mode="get-by-pk">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, MContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @return une entité <xsl:value-of select="$interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="$interface/name"/> get<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>
			

</xsl:template>



<xsl:template match="dao" mode="get-by-pk">
	<xsl:variable name="interface" select="interface"/>
	<xsl:variable name="classe" select="class"/>
	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> MContext p_oContext ) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>this.getSelectDaoQuery(), CascadeSet.NONE, new DaoSession(), p_oContext );</xsl:text>
	}

	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête	 
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>p_oDaoQuery, CascadeSet.NONE, new DaoSession(), p_oContext );</xsl:text>
	}
	
	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités	 
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>this.getSelectDaoQuery(), p_oCascadeSet, new DaoSession(), p_oContext );</xsl:text>
	}

	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
 	 * @param p_oDaoSession session Dao
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>this.getSelectDaoQuery(), CascadeSet.NONE, p_oDaoSession, p_oContext );</xsl:text>
	}

	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>p_oDaoQuery, p_oCascadeSet, new DaoSession(), p_oContext );</xsl:text>
	}
	
	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * La cascade est CascadeSet.NONE
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
 	 * @param p_oDaoSession session Dao
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>p_oDaoQuery, CascadeSet.NONE, p_oDaoSession, p_oContext );</xsl:text>
	}
	
	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * Les blocs par défaut sont utilisés
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
 	 * @param p_oDaoSession session Dao
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text> CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>this.getSelectDaoQuery(), p_oCascadeSet, p_oDaoSession, p_oContext );</xsl:text>
	}

	/**
	 * Retourne une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * <xsl:for-each select="class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 </xsl:for-each>
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
 	 * @param p_oDaoSession session Dao
 	 * @param p_oContext contexte transactionnel
 	 * @return une entité <xsl:value-of select="interface/name"/> selon la clé primaire
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public <xsl:value-of select="interface/name"/> get<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
		</xsl:text>
		
		<xsl:value-of select="interface/name"/> r_o<xsl:value-of select="interface/name"/> = null ;
		try {			
			<xsl:variable name="pkFields" select="class/identifier/attribute/field | class/identifier/association/field"/>
			<xsl:for-each select="class/identifier/descendant::attribute">
				<xsl:call-template name="dao-sql-addequalscondition-withvalue">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="queryObject">p_oDaoQuery.getSqlQuery()</xsl:with-param>
					<xsl:with-param name="fields" select="$pkFields"/>
					<xsl:with-param name="value" select="parameter-name"/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:text>PreparedStatement oStatement = p_oDaoQuery.prepareStatement(p_oContext);</xsl:text>

			try {
				p_oDaoQuery.bindValues(oStatement);
				ResultSetReader oResultSetReader = new ResultSetReader(oStatement.executeQuery());
				try {
					while ( oResultSetReader.next()) {
						r_o<xsl:value-of select="interface/name"/> = this.valueObject(oResultSetReader, p_oDaoQuery, p_oDaoSession, p_oCascadeSet, p_oContext );
					}
				}
				finally {
					oResultSetReader.close();
				}
			}
			finally {
				oStatement.close();
			}
		}
		catch( SQLException e ) {
			throw new DaoException(e);
		}
		catch( IOException e ) {
			throw new DaoException(e);
		}
		return r_o<xsl:value-of select="interface/name"/> ;
	}
</xsl:template>
</xsl:stylesheet>
